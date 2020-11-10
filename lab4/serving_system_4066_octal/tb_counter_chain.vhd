LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_counter_chain IS
END tb_counter_chain;

ARCHITECTURE test OF tb_counter_chain IS

COMPONENT counter_chain IS
GENERIC (
    radix : INTEGER := 9;
    data_width : INTEGER := 4);
PORT (
    clk, reset, take_number : IN STD_LOGIC;
    rollback : IN STD_LOGIC;
    number : OUT UNSIGNED((3 * data_width) - 1 DOWNTO 0));
END COMPONENT;

    --signals and constants
    CONSTANT data_width : INTEGER := 4;
    CONSTANT radix : INTEGER := 9;
    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;
    SIGNAL sigNumber : UNSIGNED((3 * data_width) - 1 DOWNTO 0);
    SIGNAL sigclk : STD_LOGIC := '1';
    SIGNAL sigreset, sigtake, sigrollback : STD_LOGIC;

BEGIN

    DUT : counter_chain GENERIC MAP(9, 4)
    PORT MAP(sigclk, sigreset, sigtake, sigrollback, signumber);

    --to cycle clk for the duration of the test
    sigclk <= NOT sigclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        --reset
        sigreset <= '1';
        sigtake <= '0';
        sigrollback <= '0';
        WAIT FOR HALF_PERIOD;
        sigreset <= '0';

        --test incrementing all the way up and all possible overflowing
        sigtake <= '1';
        WAIT FOR 1000 * PERIOD;
        sigtake <= '0';
        WAIT FOR PERIOD;

        --test incrementing up to a number > 100 to prepare for decrementation
        sigtake <= '1';
        WAIT FOR 111 * PERIOD;
        sigtake <= '0';
        WAIT FOR 10*PERIOD;

        --test decrementing all the way down
        sigrollback <= '1';
        WAIT FOR 111 * PERIOD;
        sigrollback <= '0';
        WAIT FOR PERIOD;

        --test decrementing while at zero to ensure no overflow
        sigrollback <= '1';
        WAIT FOR 2 * PERIOD;
        sigrollback <= '0';
        WAIT FOR PERIOD;

        --test incrementing once at zero
        sigtake <= '1';
        WAIT FOR PERIOD;
        sigtake <= '0';
        WAIT FOR PERIOD;

        WAIT;

    END PROCESS;

END test;