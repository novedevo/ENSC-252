LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_fulladd IS
END tb_fulladd;


ARCHITECTURE test of tb_fulladd is
    
COMPONENT fulladd IS
PORT(A, B, Cin : IN STD_LOGIC; --inputs
    S, Cout : OUT STD_LOGIC); --outputs
END COMPONENT;

--assigning signals for each port to stimulate them
SIGNAL sigA, sigB, sigCin : STD_LOGIC;
SIGNAL sigS, sigCout : STD_LOGIC;


--instantiate the DUT
BEGIN
DUT : fulladd
PORT MAP(A => sigA, B => sigB, Cin => sigCin,
         S => sigS, Cout => sigCout);


--code to systematically iterate through all possible values
--of the input variables:
PROCESS IS
BEGIN

--sigA alternates every 20 ns
sigA <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, 
        '1' after 100 ns, '0' after 120 ns, '1' after 140 ns;
        
--sigB alternates every 40 ns
sigB <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 120 ns;

--sigCin alternates every 80 ns
sigCin <= '0', '1' after 80 ns;


WAIT;

END PROCESS;
END test;
