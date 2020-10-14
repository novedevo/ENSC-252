LIBRARY ieee;
use IEEE.STD_LOGIC_1164.all;

ENTITY and_gate IS
PORT(a, b	: IN STD_LOGIC;
	  f		: OUT STD_LOGIC);
END and_gate;

ARCHITECTURE Behaviour of and_gate IS
BEGIN
	f <= a AND b;
END Behaviour;