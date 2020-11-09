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

    SIGNAL regQsig : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL regDsig : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL ldSig : STD_LOGIC;
    SIGNAL sigD1 : STD_LOGIC;
    SIGNAL sigD2 : STD_LOGIC;
    SIGNAL sigFlag : STD_LOGIC;
    SIGNAL sigFlagBack : STD_LOGIC;

BEGIN

    regObj : reg_4066 GENERIC MAP(data_width, N)
    PORT MAP(clk => clk, reset => reset, inc => incr, ld => ldSig, D => regDsig, Q => regQsig);

    --IFL
    ldSig <= (rollback AND (NOT incr));


    sigD1 <= '1' when ((rollback = '1') AND (incr = '0') and (regQsig = to_unsigned(0, data_width))) else '0';
    sigD2 <= '1' when ((rollback = '0') AND (incr = '1') AND (N = (regQsig+1))) else '0';

    PROCESS (rollback, incr, regQsig) IS --only needs clk because nothing that it points to is async
    BEGIN
        IF ((rollback = '1') AND (incr = '0')) THEN
            IF (regQsig = to_unsigned(0, data_width)) THEN
                regDsig <= to_unsigned(N, data_width);
            ELSE
                regDsig <= (regQsig - 1);
            END IF;
        ELSE
            regDsig <= to_unsigned(0, data_width);
        END IF;
    END PROCESS;

    PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            sigFlag <= '0';
        elsIF (rising_edge(clk)) THEN
            sigFlag <= sigD2;
        ELSE
            sigFlag <= sigFlag;
        END IF;
    END PROCESS;


    q <= regQsig;
    flag_back <= sigD1;
    flag <= sigFlag;



END structure;