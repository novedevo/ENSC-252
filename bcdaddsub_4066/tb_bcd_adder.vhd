LIBRARY ieee;
USE ieee.std_logic_1164.all;

--testbenches have empty entity sections
ENTITY tb_bcd_adder IS
END tb_bcd_adder;


ARCHITECTURE test of tb_bcd_adder is
    
    COMPONENT bcd_adder IS
    PORT( A, B  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin     : IN STD_LOGIC;
        F       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout    : OUT STD_LOGIC);
    END COMPONENT;

--assigning signals for each port to stimulate them
SIGNAL sigA, sigB, sigF: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL sigcin, sigcout : STD_LOGIC;


--instantiate the DUT
BEGIN
DUT : fulladd
PORT MAP(A => sigA, B => sigB, cin => sigCin,
         F => sigF, cout => sigCout);


--code to systematically iterate through all possible values
--of the input variables:
PROCESS IS
BEGIN

--TODO: WRITE AN ACTUAL TESTBENCH< ALSO HOW EXHAUSTIVE DOES THIS HAVE TO BE

WAIT;

END PROCESS;
END test;
