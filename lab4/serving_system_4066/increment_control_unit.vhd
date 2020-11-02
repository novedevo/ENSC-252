LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY increment_control_unit IS
    GENERIC (
        N : INTEGER := 9;
        data_width : INTEGER := 4);
    PORT (
        clk, reset : IN STD_LOGIC;
        incr, rollback : IN STD_LOGIC; --generates next number, rollback decrements
        flag, flag_back : OUT STD_LOGIC;
        q : OUT UNSIGNED(data_width - 1 DOWNTO 0)); --output value
END increment_control_unit;

ARCHITECTURE structure OF increment_control_unit IS

    COMPONENT reg_4066 IS
        GENERIC (
            data_width : INTEGER := 4;
            N : INTEGER := 9);
        PORT (
            clk, reset, inc, ld : IN STD_LOGIC;
            D : IN UNSIGNED(data_width - 1 DOWNTO 0);
            Q : OUT UNSIGNED(data_width - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL Qsig : unsigned(data_width - 1 DOWNTO 0);



BEGIN

    regObj : reg_4066 generic map(data_width, N)
    port map (clk, reset, incr, ldSig, Dsig, Qsig)

    --TODO

END structure;