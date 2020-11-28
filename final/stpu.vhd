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
    SIGNAL donesig, mmuLdSig, mmuLdWSig : STD_LOGIC;
    SIGNAL y0sig, y1sig, y2sig, w0sig, w1sig, w2sig, a0sig, a1sig, a2sig : unsigned(7 DOWNTO 0);

    signal uclr0, uclr1, uclr2, urden0, urden1, urden2, uwren0, uwren1, uwren2, wclr, wrden, wwren : STD_LOGIC;
    signal uaddr0, uaddr1, uaddr2, waddr : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal udata0, udata1, udata2, uq1, uq2, uq0 : STD_LOGIC_VECTOR(7 downto 0);
    signal wdata, w1 : STD_LOGIC_VECTOR(23 DOWNTO 0);

BEGIN

    --instantiate components
    au : activation_unit
    PORT MAP(clk, reset, hard_reset, stall, donesig, y0sig, y1sig, y2sig, y0, y1, y2);

    mmu : matrix_multiplication_unit
    PORT MAP(clk, reset, hard_reset, mmuLdSig, mmuLdWSig, stall, a0sig, a1sig, a2sig, w0sig, w1sig, w2sig, y0sig, y1sig, y2sig);

    u0 : uram
    PORT MAP(uclr0, uaddr0, clk, udata0, urden0, uwren0, uq0);
    u1 : uram
    PORT MAP(uclr1, uaddr1, clk, udata1, urden1, uwren1, uq1);
    u2 : uram
    PORT MAP(uclr2, uaddr2, clk, udata2, urden2, uwren2, uq2);

    w : wram
    PORT MAP(wclr, waddr, clk, wdata, wrden, wwren, wq);

END structure;