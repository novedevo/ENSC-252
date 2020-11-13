LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_box2 IS
END ENTITY;

ARCHITECTURE test OF tb_box2 IS

    COMPONENT box IS
        GENERIC (
            data_width : INTEGER := 6;
            N : INTEGER := 33;
            morse : STD_LOGIC_VECTOR);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            code_out : OUT STD_LOGIC);
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;

    SIGNAL sigclk : STD_LOGIC;
    SIGNAL sigreset : STD_LOGIC;
    SIGNAL sigenable : STD_LOGIC;
    SIGNAL sigcode_out : STD_LOGIC;

BEGIN

    DUT : box GENERIC MAP(6, 43, "11101010001000101010111000111011101110000000")
    PORT MAP(sigclk, sigreset, sigenable, sigcode_out);

    --to cycle clk for the duration of the test
    sigclk <= NOT sigclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        --reset
        sigreset <= '1';
        sigenable <= '1';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

        WAIT FOR half_period * 44; --to ensure looping works

        --reset
        sigreset <= '1';
        sigenable <= '0';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

    END PROCESS;

END ARCHITECTURE;