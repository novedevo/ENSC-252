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
    SIGNAL incrRollbackSig : STD_LOGIC;

BEGIN

    regObj : reg_4066 GENERIC MAP(data_width, N)
    PORT MAP(clk => clk, reset => reset, inc => incr, ld => ldSig, D => regDsig, Q => regQsig)

    PROCESS (reset) IS
        IF (reset) THEN
            regQsig <= to_unsigned('0', data_width);
            regDSig <= to_unsigned('0', data_width);
            ldSig <= '0';
            sigD1 <= '0';
            sigD2 <= '0';
            sigFlagBack <= '0';
            sigFlag <= '0';
            incrRollbackSig <= '0';
            --and more
        END IF;
    END PROCESS;

    --IFL
    incrRollbackSig <= (rollback AND (NOT incr));
    ldSig <= incrRollbackSig;

    PROCESS (clk) IS --only needs clk because nothing that it points to is async
        IF (incrRollbackSig = '1') THEN
            IF (Qsig = to_unsigned('0', data_width)) THEN
                regDsig <= N;
                sigD1 <= '1';
            ELSE
                regDsig <= (Qsig - to_unsigned('1', data_width));
                sigD1 <= '0';
            END IF;
        ELSE
            sigD1 <= '0';
            regDsig <= to_unsigned('0', data_width);
        END IF;
    END PROCESS;

    PROCESS (clk, reset) IS
        IF (reset) THEN
            sigFlagBack <= '0';
            sigFlag <= '0';
        END IF;
        IF (rising_edge(clk)) THEN
            sigFlagBack <= sigD1;
            sigFlag <= sigD2;
        ELSE
            sigFlagBack <= sigFlagBack;
            sigFlag <= sigFlag;
        END IF;
    END PROCESS;

    PROCESS (rollback, incr, Qsig) IS
        IF ((NOT rollback) AND incr AND (N = (Qsig + to_unsigned('1', data_width)))) THEN
            sigD2 <= '1';
        ELSE
            sigD2 <= '0';
        END IF;
    END PROCESS;

END structure;