LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--testbenches have empty entity sections
ENTITY tb_fourbitadd_worst IS
END tb_fourbitadd_worst;

ARCHITECTURE test OF tb_fourbitadd_worst IS

	COMPONENT fourbitadd IS
		PORT (
			A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cin : IN STD_LOGIC;
			S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			Cout : OUT STD_LOGIC);
	END COMPONENT;

	--assigning signals for each port to stimulate them
	SIGNAL sigA, sigB : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL sigCin : STD_LOGIC;
	SIGNAL sigS : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL sigCout : STD_LOGIC;

BEGIN
	--instantiate the DUT
	DUT : fourbitadd
	PORT MAP(
		A => sigA, B => sigB, Cin => sigCin,
		S => sigS, Cout => sigCout);

	--code to test a variety of inputs and corner cases
	PROCESS IS
	BEGIN

		--for longest delay and most accurate readings, test for ~1000ns at a resolution of 10ps
		--longest delays should be in the neighbourhood of 9.46ns
		--some delays are shorter, such as 9.33ns, this is coincidental and due to the unsettled 
		--values happening to line up with the final output

		--corner cases:
		sigA <= "0000";
		sigB <= "0000";
		sigCin <= '0';
		WAIT FOR 20 ns;

		sigA <= "1111";
		sigB <= "1111";
		sigCin <= '1';
		WAIT FOR 20 ns;

		-- a few arbitrary random selections
		sigA <= "1100";
		sigB <= "0111";
		sigCin <= '1';
		WAIT FOR 20 ns;

		sigA <= "0001";
		sigB <= "1111";
		sigCin <= '0';
		WAIT FOR 20 ns;

		sigA <= "1101";
		sigB <= "1010";
		sigCin <= '0';
		WAIT FOR 20 ns;

		--prepare for worst case analysis
		sigCin <= '0';

		-- Worst case scenarios
		FOR i IN 0 TO 15 LOOP
			sigA <= STD_LOGIC_VECTOR(to_unsigned(i, sigA'length));
			sigB <= NOT STD_LOGIC_VECTOR(to_unsigned(i, sigB'length));
			WAIT FOR 20 ns;
		END LOOP;

		--literally all other options
		--commented out by default, can be enabled
		--FOR i IN "0000" TO "1111" LOOP
		--	FOR j IN "0000" TO "1111" LOOP
		--		sigA <= i;
		--		sigB <= j;
		--		WAIT FOR 20 ns;
		--	END LOOP;
		--END LOOP;

		WAIT;

	END PROCESS;
END test;