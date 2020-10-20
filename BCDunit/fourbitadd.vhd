LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fourbitadd IS
	PORT(A, B : IN STD_LOGIC_VECTOR(3 downto 0);
		Cin : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(3 downto 0);
		Cout : OUT STD_LOGIC);
		
END fourbitadd;

ARCHITECTURE Structure of fourbitadd is

	COMPONENT fulladd IS
		PORT(A, B, Cin : IN STD_LOGIC; --inputs
    		S, Cout : OUT STD_LOGIC); --outputs
	END COMPONENT;

	signal C1, C2, C3 : STD_LOGIC;

	BEGIN

		Obj0 : fulladd
			port map (A => A(0), B => B(0), Cin => Cin, S => S(0), Cout => C1);
		
		Obj1 : fulladd
			port map (A => A(1), B => B(1), Cin => C1, S => S(1), Cout => C2);

		Obj2 : fulladd
			port map (A => A(2), B => B(2), Cin => C2, S => S(2), Cout => C3);

		Obj3 : fulladd
			port map (A => A(3), B => B(3), Cin => C3, S => S(3), Cout => Cout);


END Structure;
