LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fulladd IS
	PORT(A, B, Cin : IN STD_LOGIC;
		S, Cout : OUT STD_LOGIC);
END fulladd;

ARCHITECTURE Behaviour of fulladd is

BEGIN

    Cout <= (A and B) or (Cin and (A xor B));
    S <= (Cin xor A xor B);
					
END Behaviour;
