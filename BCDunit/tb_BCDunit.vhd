LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_BCDunit IS
END tb_BCDunit;

ARCHITECTURE test OF tb_BCDunit IS

	COMPONENT BCDunit IS
		PORT (
			A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			mode : IN STD_LOGIC;
			segOut0, segOut1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT hex_display IS
		PORT (
			bcd_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			number : OUT STD.STANDARD.INTEGER
		);
	END COMPONENT;

	--assigning signals for each port to stimulate them
	SIGNAL sigA, sigB : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL sigmode : STD_LOGIC;
	SIGNAL sigSegOut0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sigSegOut1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sevenSegOut0 : INTEGER := 0;
	SIGNAL sevenSegOut1 : INTEGER := 0;

BEGIN
	--instantiate the DUT
	DUT : BCDunit
	PORT MAP(
		A => sigA, B => sigB, mode => sigMode,
		segOut0 => sigSegOut0, segOut1 => sigSegOut1);

	seg7_0 : hex_display
	PORT MAP(bcd_in => sigSegOut0, number => sevenSegOut0);

	seg7_1 : hex_display
	PORT MAP(bcd_in => sigSegOut1, number => sevenSegOut1);

	--code to test a variety of inputs and corner cases
	PROCESS IS
	BEGIN

		FOR i IN 0 TO 9 LOOP
			FOR j IN 0 TO 9 LOOP
				sigMode <= '0';
				sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
				sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
				WAIT FOR 20 ns;
			END LOOP;
		END LOOP;

		FOR i IN 0 TO 9 LOOP
			FOR j IN 0 TO 9 LOOP
				sigMode <= '1';
				sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
				sigB <= STD_LOGIC_VECTOR(to_unsigned(j, sigB'length));
				WAIT FOR 20 ns;
			END LOOP;
		END LOOP;

		WAIT;

	END PROCESS;
END test;