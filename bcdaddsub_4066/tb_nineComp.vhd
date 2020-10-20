LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_nineComp IS
END tb_nineComp;


ARCHITECTURE test of tb_nineComp is
    
    COMPONENT nineComp IS
    PORT( X     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          mode  : IN STD_LOGIC;
          Y     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

--assigning signals for each port to stimulate them
SIGNAL sigX, sigY : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL sigMode : STD_LOGIC;


--instantiate the DUT
BEGIN
DUT : nineComp
PORT MAP(X => sigX, Y => sigY, mode => sigMode);


--code to systematically iterate through all possible values
--of the input variables in 640ns:
PROCESS IS
BEGIN

--first, test with mode set to 0.
sigMode <= '0';

--X(0) alternates every 20 ns
sigX(0) <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, 
        '1' after 100 ns, '0' after 120 ns, '1' after 140 ns, '0' after 160 ns, 
        '1' after 180 ns, '0' after 200 ns, '1' after 220 ns, '0' after 240 ns, 
        '1' after 260 ns, '0' after 280 ns, '1' after 300 ns;
        
--X(1) alternates every 40 ns
sigX(1) <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 120 ns, '0' after 160 ns, 
        '1' after 200 ns, '0' after 240 ns, '1' after 280 ns;

--X(2) alternates every 80 ns
sigX(2) <= '0', '1' after 80 ns, '0' after 160 ns, '1' after 240 ns;

--and X(3) only alternates every 160 ns
sigX(3) <= '0', '1' after 160 ns;


wait for 400 ns;

--then set mode to 1 and redo it
sigMode <= '1';

--X(0) alternates every 20 ns
sigX(0) <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, '0' after 80 ns, 
        '1' after 100 ns, '0' after 120 ns, '1' after 140 ns, '0' after 160 ns, 
        '1' after 180 ns, '0' after 200 ns, '1' after 220 ns, '0' after 240 ns, 
        '1' after 260 ns, '0' after 280 ns, '1' after 300 ns;
        
--X(1) alternates every 40 ns
sigX(1) <= '0', '1' after 40 ns, '0' after 80 ns, '1' after 120 ns, '0' after 160 ns, 
        '1' after 200 ns, '0' after 240 ns, '1' after 280 ns;

--X(2) alternates every 80 ns
sigX(2) <= '0', '1' after 80 ns, '0' after 160 ns, '1' after 240 ns;

--and X(3) only alternates every 160 ns
sigX(3) <= '0', '1' after 160 ns;


WAIT;

END PROCESS;
END test;
