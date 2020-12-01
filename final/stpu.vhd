LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY stpu IS
    PORT (
        clk, reset, hard_reset, setup, GO, stall : IN STD_LOGIC;
        weights, a_in : IN UNSIGNED (23 DOWNTO 0);
        y0, y1, y2 : OUT bus_width
    );
END ENTITY;

ARCHITECTURE structure OF stpu IS

    --components
    COMPONENT activation_unit IS
        PORT (
            clk, reset, hard_reset, stall : IN STD_LOGIC;
            done : OUT STD_LOGIC;
            y_in0, y_in1, y_in2 : IN UNSIGNED(7 DOWNTO 0);
            row0, row1, row2 : OUT bus_width);
    END COMPONENT;

    COMPONENT matrix_multiplication_unit IS
        PORT (
            clk, reset, hard_reset, ld, ld_w, stall : IN STD_LOGIC;
            a0, a1, a2, w0, w1, w2 : IN UNSIGNED(7 DOWNTO 0);
            y0, y1, y2 : OUT UNSIGNED(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT URAM
        PORT (
            aclr : IN STD_LOGIC := '0';
            address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            clock : IN STD_LOGIC := '1';
            data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            rden : IN STD_LOGIC := '1';
            wren : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT WRAM
        PORT (
            aclr : IN STD_LOGIC := '0';
            address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            clock : IN STD_LOGIC := '1';
            data : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
            rden : IN STD_LOGIC := '1';
            wren : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
        );
    END COMPONENT;

    --signals

    SIGNAL mode : t_MODE_STATE;
    SIGNAL loaded_weight : t_WEIGHT_STATE;

    SIGNAL donesig, mmuLdSig, mmuLdWSig : STD_LOGIC;
    SIGNAL y0sig, y1sig, y2sig, w0sig, w1sig, w2sig, a0sig, a1sig, a2sig : unsigned(7 DOWNTO 0);

    SIGNAL resetSig : STD_LOGIC;

    --consider setting all these to 0 initially
    signal uwren, urden : std_logic_vector(2 downto 0);
    SIGNAL wrden, wwren : STD_LOGIC;
    SIGNAL uaddr0, uaddr1, uaddr2, waddr : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL udata0, udata1, udata2, uq1, uq2, uq0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wdata, w1 : STD_LOGIC_VECTOR(23 DOWNTO 0);

BEGIN

    resetSig <= reset OR hard_reset;

    --instantiate components
    au : activation_unit
    PORT MAP(clk, reset, hard_reset, stall, donesig, y0sig, y1sig, y2sig, y0, y1, y2);

    mmu : matrix_multiplication_unit
    PORT MAP(clk, reset, hard_reset, mmuLdSig, mmuLdWSig, stall, a0sig, a1sig, a2sig, w0sig, w1sig, w2sig, y0sig, y1sig, y2sig);

    u0 : uram
    PORT MAP(resetSig, uaddr0, clk, a_in(7 downto 0), urden(0), uwren(0), uq0);
    u1 : uram
    PORT MAP(resetSig, uaddr1, clk, a_in(15 downto 8), urden(1), uwren(1), uq1);
    u2 : uram
    PORT MAP(resetSig, uaddr2, clk, a_in(23 downto 16), urden(2), uwren(2), uq2);

    w : wram
    PORT MAP(hard_reset, waddr, clk, weights, wrden, wwren, wq);

    PROCESS (clk, reset, hard_reset) IS
    BEGIN
        IF (hard_reset = '1') THEN
            loaded_weight <= none;
            mode <= idle;
        ELSIF (reset = '1') THEN
            mode <= idle;

        ELSIF (falling_edge(clk)) THEN --falling edge to align it better with the sram

            IF (setup = '1' AND (mode = idle OR mode = go)) THEN
                mode <= setup;
                wwren <= '1';
                loaded_weight <= first;
                waddr <= "00";

                uwren <= "111";
                udata0 <= a_in(7 downto 0);

            elsif (mode = setup and loaded_weight = first) then
                waddr <= "01";
                loaded_weight <= second;
            elsif (mode = setup and loaded_weight = second) then
                waddr <= "10";
                loaded_weight <= done;
            END IF;



        END IF;
    END PROCESS;

END structure;