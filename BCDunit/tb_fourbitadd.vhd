LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_fourbitadd IS
END tb_fourbitadd;


ARCHITECTURE test of tb_fourbitadd is
    
COMPONENT fourbitadd IS
PORT(A, B : IN STD_LOGIC_VECTOR(3 downto 0);
		Cin : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(3 downto 0);
		Cout : OUT STD_LOGIC);
END COMPONENT;

--assigning signals for each port to stimulate them
SIGNAL sigA, sigB : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL sigCin : STD_LOGIC;
SIGNAL sigS : STD_LOGIC_VECTOR(3 downto 0);
SIGNAL sigCout : STD_LOGIC;


--instantiate the DUT
BEGIN
DUT : fourbitadd
PORT MAP(A => sigA, B => sigB, Cin => sigCin,
         S => sigS, Cout => sigCout);


--code to test a variety of inputs and corner cases
PROCESS IS
BEGIN

sigA <= ("0010");
sigB <= ("1001");
sigCin <= '1';
wait for 20 ns;

sigA <= ("0000");
sigB <= ("0000");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1111");
sigB <= ("1111");
sigCin <= '1';
wait for 20 ns;

sigA <= ("1110");
sigB <= ("1101");
sigCin <= '0';
wait for 20 ns;

WAIT;

END PROCESS;
END test;
