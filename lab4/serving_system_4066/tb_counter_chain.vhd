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
        WAIT FOR 15 ns;
        sigreset <= '0';

        --test incrementing all the way up and overflowing, twice
        sigtake <= '1';
        WAIT FOR 2001 * PERIOD;
        sigtake <= '0';
        WAIT FOR PERIOD;

        WAIT;

    END PROCESS;

END test;