LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_serving_system IS
END tb_serving_system;

ARCHITECTURE test OF tb_serving_system IS

component serving_system IS
    GENERIC (
        radix : INTEGER := 9;
        data_width : INTEGER := 4);
    PORT (
        clk, reset, take_number : IN STD_LOGIC;
        rollback : IN STD_LOGIC;
        bcd0, bcd1, bcd2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END component;

COMPONENT hex_display IS
PORT (
    bcd_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    number : OUT STD.STANDARD.INTEGER
);
END COMPONENT;

    --signals and constants
    CONSTANT data_width : INTEGER := 4;
    CONSTANT radix : INTEGER := 9;
    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;
    SIGNAL sigclk : STD_LOGIC := '1';
    SIGNAL sigreset, sigtake, sigrollback : STD_LOGIC;
    signal sigBCD0, sigBCD1, sigBCD2 : std_logic_vector (6 downto 0);
    SIGNAL sevenSegOut0 : INTEGER := 0;
    SIGNAL sevenSegOut1 : INTEGER := 0;
    SIGNAL sevenSegOut2 : INTEGER := 0;

BEGIN

    DUT : serving_system GENERIC MAP(9, 4)
    PORT MAP(sigclk, sigreset, sigtake, sigrollback, sigBCD0, sigBCD1, sigBCD2);

    hex0 : hex_display PORT MAP (sigBCD0, sevenSegOut0);
    hex1 : hex_display PORT MAP (sigBCD1, sevenSegOut1);
    hex2 : hex_display PORT MAP (sigBCD2, sevenSegOut2);

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

        --test all incrementation and overflowing
        sigtake <= '1';
        WAIT FOR 1000 * PERIOD;
        sigtake <= '0';
        WAIT FOR PERIOD;

        --test incrementing all the way back up to prepare for the decrementing test
        sigtake <= '1';
        WAIT FOR 999 * PERIOD;
        sigtake <= '0';
        WAIT FOR PERIOD;

        --test decrementing all the way down
        sigrollback <= '1';
        WAIT FOR 1000 * PERIOD;
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