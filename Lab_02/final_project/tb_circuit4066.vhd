LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_circuit4066 IS
END tb_circuit4066;


ARCHITECTURE test of tb_circuit4066 is
    
COMPONENT circuit4066 IS
PORT(D0, D1, D2, D3 : IN STD_LOGIC; --inputs
    canonical_out, kmap_out : OUT STD_LOGIC); --outputs
END COMPONENT;

--assigning signals for each port to stimulate them
SIGNAL sig0, sig1, sig2, sig3 : STD_LOGIC;
SIGNAL canonsig, ksig : STD_LOGIC;


--instantiate the DUT
BEGIN
DUT : circuit4066
PORT MAP(D0 => sig0, D1 => sig1, D2 => sig2, D3 => sig3,
         canonical_out => canonsig, kmap_out => ksig);


--code to systematically iterate through all possible values
--of the input variables:
PROCESS IS
BEGIN

--sig0 alternates every 20 ns
sig0 <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, 
        '1' after 100 ns, '0' after 120 ns, '1' after 140 ns, '0' after 160 ns, 
        '1' after 180 ns, '0' after 200 ns, '1' after 220 ns, '0' after 240 ns, 
        '1' after 260 ns, '0' after 280 ns, '1' after 300 ns;
        
--sig1 alternates every 40 ns
sig1 <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 120 ns, '0' after 160 ns, 
        '1' after 200 ns, '0' after 240 ns, '1' after 280 ns;

--sig2 alternates every 80 ns
sig2 <= '0', '1' after 80 ns, '0' after 160 ns, '1' after 240 ns;

--and sig3 only alternates every 160 ns
sig3 <= '0', '1' after 160 ns;

WAIT;

END PROCESS;
END test;
