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
    SIGNAL ramLoaded : t_WEIGHT_STATE;
    SIGNAL wLoaded : INTEGER;

    SIGNAL donesig, mmuLdSig, mmuLdWSig : STD_LOGIC;
    SIGNAL ysig, wsig, asig : bus_width;

    SIGNAL resetSig : STD_LOGIC;

    --consider setting all these to 0 initially
    SIGNAL uwren, urden : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL uaddr : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL wrden, wwren : STD_LOGIC;
    SIGNAL waddr : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL uq1, uq2, uq0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wdata, wq : STD_LOGIC_VECTOR(23 DOWNTO 0);

BEGIN

    resetSig <= reset OR hard_reset;

    --instantiate components
    au : activation_unit
    PORT MAP(clk, reset, hard_reset, stall, donesig, ysig(0), ysig(1), ysig(2), y0, y1, y2);

    mmu : matrix_multiplication_unit
    PORT MAP(clk, reset, hard_reset, mmuLdSig, mmuLdWSig, stall, asig(0), asig(1), asig(2), wsig(0), wsig(1), wsig(2), ysig(0), ysig(1), ysig(2));

    u0 : uram
    PORT MAP(resetSig, uaddr(1 DOWNTO 0), clk, std_logic_vector(a_in(7 DOWNTO 0)), urden(0), uwren(0), uq0);
    u1 : uram
    PORT MAP(resetSig, uaddr(3 DOWNTO 2), clk, std_logic_vector(a_in(15 DOWNTO 8)), urden(1), uwren(1), uq1);
    u2 : uram
    PORT MAP(resetSig, uaddr(5 DOWNTO 4), clk, std_logic_vector(a_in(23 DOWNTO 16)), urden(2), uwren(2), uq2);

    w : wram
    PORT MAP(hard_reset, waddr, clk, std_logic_vector(weights), wrden, wwren, wq);

    PROCESS (clk, reset, hard_reset) IS
    BEGIN
        IF (hard_reset = '1') THEN
            ramLoaded <= none;
            mode <= idle;
        ELSIF (reset = '1') THEN
            mode <= idle;

        ELSIF (falling_edge(clk)) THEN --falling edge to align it better with the sram

            IF (setup = '1' AND (mode = idle)) THEN
                mode <= t_setup;
                wwren <= '1';
                ramLoaded <= first;
                waddr <= "00";

                uwren <= "111";
                uaddr <= "000000";

            ELSIF (mode = t_setup AND ramLoaded = first) THEN
                waddr <= "01";
                uaddr <= "010101";
                ramLoaded <= second;
            ELSIF (mode = t_setup AND ramLoaded = second) THEN
                waddr <= "10";
                uaddr <= "101010";
                ramLoaded <= done;

            ELSIF (mode = t_setup AND ramLoaded = done) THEN
                waddr <= "00";
                uaddr <= "000000";
                wwren <= '0';
                uwren <= "000";
                mode <= idle;
            END IF;

            IF (go = '1' AND mode = idle) THEN
                mode <= t_go;
                mmuLdWSig <= '1';

                wsig(0) <= unsigned(uq0);
                wLoaded <= 1;
            ELSIF (mode = t_go AND wLoaded = 1) THEN
                wsig(0) <= unsigned(uq1);
                wsig(1) <= unsigned(uq0);
            END IF;
        END IF;
    END PROCESS;

END structure;