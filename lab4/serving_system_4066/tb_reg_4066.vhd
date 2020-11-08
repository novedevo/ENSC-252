LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_reg_4066 IS
END tb_reg_4066;

ARCHITECTURE test OF reg_4066 IS

    COMPONENT reg_4066 IS
        GENERIC (
            data_width : INTEGER := 4;
            N : INTEGER := 9);
        PORT (
            clk, reset, inc, ld : IN STD_LOGIC;
            D : IN UNSIGNED(data_width - 1 DOWNTO 0);
            Q : OUT UNSIGNED(data_width - 1 DOWNTO 0));
    END COMPONENT;

    --signals and constants
    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;
    SIGNAL sigQ, sigD : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL sigclk : STD_LOGIC := '1';
    SIGNAL sigreset, siginc, sigld : STD_LOGIC;

BEGIN

    DUT : reg_4066
    GENERIC MAP(4, 9)
    PORT MAP(sigclk, sigreset, siginc, sigld, sigD, sigQ);

    PROCESS IS
    BEGIN

        --to cycle clk for the duration of the test
        sigclk <= NOT sigclk AFTER HALF_PERIOD;

        --reset
        sigreset <= '1';
        siginc <= '0';
        sigld <= '0';
        sigD <= to_unsigned(0, data_width);
        WAIT FOR 15 ns;
        sigreset <= '0';

        --test incrementing all the way up and overflowing, twice
        siginc <= '1';
        WAIT FOR 20 * PERIOD;
        siginc <= '0';
        WAIT FOR PERIOD;

        --test loading
        sigld <= '1';
        sigD <= to_unsigned(5, data_width);
        WAIT FOR 2 * PERIOD;
        sigld <= '0';
        WAIT FOR PERIOD;

        --test incrementing all the way from a loaded starting place
        siginc <= '1';
        WAIT FOR 10 * PERIOD;
        siginc <= '0';
        WAIT FOR PERIOD;

        --test resetting again, with set values
        sigreset <= '0';
        WAIT FOR PERIOD;

    END PROCESS;

END test;