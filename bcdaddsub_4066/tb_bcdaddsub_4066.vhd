LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_bcdaddsub_4066 IS
END tb_bcdaddsub_4066;

ARCHITECTURE test OF tb_bcdaddsub_4066 IS

	COMPONENT bcdaddsub_4066 IS
		PORT (
			A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			mode : IN STD_LOGIC;
			sum : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cout : OUT STD_LOGIC);
	END COMPONENT;

	--assigning signals for each port to stimulate them
	SIGNAL sigA, sigB : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL sigmode : STD_LOGIC;
	SIGNAL sigSum : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL sigCout : STD_LOGIC;

BEGIN
	--instantiate the DUT
	DUT : bcdaddsub_4066
	PORT MAP(
		A => sigA, B => sigB, mode => sigMode,
		sum => sigSum, Cout => sigCout);

	--code to test a variety of inputs and corner cases
	PROCESS IS
	BEGIN

		FOR i IN 0 TO 9 LOOP
			FOR j IN 0 TO 9 LOOP
				sigMode <= '0';
				sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
				sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
				WAIT FOR 20 ns;

				sigMode <= '1';
				sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
				sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
				WAIT FOR 20 ns;
			END LOOP;
		END LOOP;

		WAIT;

	END PROCESS;
END test;