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

    --signals
    SIGNAL sigQ, sigD : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL sigclk, sigreset, siginc, sigld : STD_LOGIC;

BEGIN

    DUT : reg_4066
    GENERIC MAP(4, 9)
    PORT MAP(sigclk, sigreset, siginc, sigld, sigD, sigQ)

    PROCESS IS
    BEGIN
        --reset
        sigreset <= '1';
        sigclk <= '1';
        WAIT FOR 20 ns;
        sigclk <= '0';
        sigreset <= 0;
        siginc <= '0';
        sigld <= '0';
        sigD <= 0;
        WAIT FOR 20 ns;

        LOOP
            --to cycle clk for the duration of the test
            sigclk <= NOT sigclk AFTER 10 ns;
        END LOOP;

        --test incrementing all the way to 10 and back again
        siginc <= '1';
        WAIT FOR 20 * 20 ns;
        siginc <= '0';
        WAIT FOR 20 ns;

        sigld <= '1';
        sigD <= 5;
        WAIT FOR 40 ns;
        sigld <= '0';
        WAIT FOR 20 ns;

        --test incrementing all the way from a loaded starting place
        siginc <= '1';
        WAIT FOR 20 * 20 ns;
        siginc <= '0';
        WAIT FOR 20 ns;

        --test resetting again
        sigreset <= '0';
        WAIT FOR 20 ns;

    END PROCESS

END test;