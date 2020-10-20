LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbench entities are always empty
ENTITY tb_SevenSeg IS
END tb_SevenSeg;

ARCHITECTURE test OF tb_SevenSeg IS

	COMPONENT SevenSeg IS
		PORT (
			D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Y : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
	END COMPONENT;

	COMPONENT hex_display IS
		PORT (
			bcd_in : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			number : OUT STD.STANDARD.INTEGER
		);
	END COMPONENT;

	--fill in rest of signals here
	SIGNAL hexsig : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL sevenSegOut : INTEGER := 0;
	SIGNAL sigD : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

	DUT : SevenSeg
	PORT MAP(
		D => sigD,
		Y => hexsig);

	seg7 : hex_display
	PORT MAP(bcd_in => hexsig, number => sevenSegOut);

	PROCESS
	BEGIN

		FOR i IN 0 TO 15 LOOP
			sigD <= STD_LOGIC_VECTOR(to_unsigned(i, sigD'length));
			WAIT FOR 20 ns;
		END LOOP;
		WAIT;

	END PROCESS;
END test;