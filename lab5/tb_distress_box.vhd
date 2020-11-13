LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_distress_box IS
END ENTITY;

ARCHITECTURE test OF tb_distress_box IS

    COMPONENT box IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            sel : IN STD_LOGIC;
            code_out : OUT STD_LOGIC
        );
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;

    SIGNAL sigclk : STD_LOGIC;
    SIGNAL sigreset : STD_LOGIC;
    SIGNAL sigenable : STD_LOGIC;
    SIGNAL sigsel : STD_LOGIC;
    SIGNAL sigcode_out : STD_LOGIC;

BEGIN

    DUT : distress_box PORT MAP(sigclk, sigreset, sigenable, sigsel, sigcode_out);

    --to cycle clk for the duration of the test
    sigclk <= NOT sigclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        --reset
        sigreset <= '1';
        sigenable <= '1';
        sigsel <= '0';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

        WAIT FOR half_period * 34; --to ensure looping works

        --reset
        sigreset <= '1';
        sigenable <= '0';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

        WAIT FOR half_period * 5;

        --reset
        sigreset <= '1';
        sigenable <= '1';
        sigsel <= '1';
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