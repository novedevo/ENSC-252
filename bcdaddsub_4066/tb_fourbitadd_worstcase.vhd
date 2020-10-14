LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_fourbitadd_worst IS
END tb_fourbitadd_worst;


ARCHITECTURE test of tb_fourbitadd_worst is
    
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

--for longest delay and most accurate readings, test for ~900ns at a resolution of 100ps
--longest delays should be in the neighbourhood of 9.46ns
--some delays are shorter, such as 9.33ns, this is coincidental and due to the unsettled values happening to line up with the final output
sigA <= ("0000");
sigB <= ("1111");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0001");
sigB <= ("1110");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0010");
sigB <= ("1101");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0011");
sigB <= ("1100");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0100");
sigB <= ("1011");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0101");
sigB <= ("1010");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0110");
sigB <= ("1001");
sigCin <= '0';
wait for 20 ns;

sigA <= ("0111");
sigB <= ("1000");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1000");
sigB <= ("0111");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1001");
sigB <= ("0110");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1010");
sigB <= ("0101");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1011");
sigB <= ("0100");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1100");
sigB <= ("0011");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1101");
sigB <= ("0010");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1110");
sigB <= ("0001");
sigCin <= '0';
wait for 20 ns;

sigA <= ("1111");
sigB <= ("0000");
sigCin <= '0';
wait for 20 ns;


WAIT;

END PROCESS;
END test;
