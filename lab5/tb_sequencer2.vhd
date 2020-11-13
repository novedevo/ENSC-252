LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_sequencer IS
END ENTITY;

ARCHITECTURE test OF tb_sequencer IS

    COMPONENT sequencer IS
    GENERIC (
        data_width : INTEGER := 6;
        N : INTEGER := 33);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        count : OUT unsigned);
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;

    SIGNAL sigclk : STD_LOGIC;
    SIGNAL sigreset : STD_LOGIC;
    SIGNAL sigcount : STD_LOGIC;

BEGIN

    DUT : sequencer GENERIC MAP(6, 43)
    PORT MAP(sigclk, sigreset, sigcount);

    --to cycle clk for the duration of the test
    sigclk <= NOT sigclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        --reset
        sigreset <= '1';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

    END PROCESS;

END ARCHITECTURE;