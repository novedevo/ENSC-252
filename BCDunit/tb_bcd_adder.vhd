LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_bcd_adder IS
END tb_bcd_adder;

ARCHITECTURE test OF tb_bcd_adder IS

    COMPONENT bcd_adder IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : IN STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    --assigning signals for each port to stimulate them
    SIGNAL sigA, sigB, sigF : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sigcin, sigcout : STD_LOGIC;

BEGIN
    --instantiate the DUT
    DUT : bcd_adder
    PORT MAP(
        A => sigA, B => sigB, cin => sigCin,
        F => sigF, cout => sigCout);

    --code to systematically iterate through all possible values
    --of the input variables:
    PROCESS IS
    BEGIN

        FOR i IN 0 TO 15 LOOP
            FOR j IN 0 TO 15 LOOP
                sigCin <= '0';
                sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
                sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
                WAIT FOR 20 ns;
            END LOOP;
        END LOOP;

        FOR i IN 0 TO 15 LOOP
            FOR j IN 0 TO 15 LOOP
                sigCin <= '1';
                sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
                sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
                WAIT FOR 20 ns;
            END LOOP;
        END LOOP;

        WAIT;

    END PROCESS;
END test;