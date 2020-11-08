LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_increment_control_unit IS
END tb_increment_control_unit;

ARCHITECTURE test OF tb_increment_control_unit IS

    COMPONENT increment_control_unit IS
        GENERIC (
            N : INTEGER := 9;
            data_width : INTEGER := 4);
        PORT (
            clk, reset : IN STD_LOGIC;
            incr, rollback : IN STD_LOGIC; --generates next number, rollback decrements
            flag, flag_back : OUT STD_LOGIC;
            q : OUT UNSIGNED(data_width - 1 DOWNTO 0)); --output value
    END COMPONENT;

    --signals and constants
    CONSTANT data_width : INTEGER := 4;
    CONSTANT N : INTEGER := 9;
    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;
    SIGNAL sigQ : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL sigclk : STD_LOGIC := '1';
    SIGNAL sigreset, sigincr, sigrollback, sigflag, sigflagback : STD_LOGIC;

BEGIN

    DUT : increment_control_unit GENERIC MAP(9, 4)
    PORT MAP(sigclk, sigreset, sigincr, sigrollback, sigflag, sigflagback, sigQ);

    --to cycle clk for the duration of the test
    sigclk <= NOT sigclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        --reset
        sigreset <= '1';
        sigincr <= '0';
        sigrollback <= '0';
        WAIT FOR 15 ns;
        sigreset <= '0';

        --test incrementing all the way up and overflowing, twice
        sigincr <= '1';
        WAIT FOR 20 * PERIOD;
        sigincr <= '0';
        WAIT FOR PERIOD;

        --test decrementing all the way down and overflowing, twice
        sigrollback <= '1';
        WAIT FOR 20 * PERIOD;
        sigrollback <= '0';
        WAIT FOR PERIOD;

        --test resetting again
        sigreset <= '1';
        WAIT FOR PERIOD;
        sigreset <= '0';
        WAIT FOR 2*PERIOD;

        --test decrementing once and waiting
        sigrollback <= '1';
        WAIT FOR PERIOD;
        sigrollback <= '0';
        WAIT FOR 2 * PERIOD;

        --test incrementing once and waiting
        sigincr <= '1';
        WAIT FOR PERIOD;
        sigincr <= '0';
        WAIT FOR 2 * PERIOD;

        WAIT;

    END PROCESS;

END test;