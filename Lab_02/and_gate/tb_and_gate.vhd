LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

--testbench entities are always empty
ENTITY tb_and_gate IS
END tb_and_gate;

ARCHITECTURE test of tb_and_gate IS

--1)------------------------------------------------------------
--copy and paste the ENTITY and change to COMPONENT
COMPONENT and_gate IS
PORT(a, b	: IN STD_LOGIC;
	  f		: OUT STD_LOGIC);
END COMPONENT;
--this component will be used as a DUT (Device under test), ou will apply stimulus to the DUT's inputs
--to verify correct/expected functionality at the outputs


--2)-------------------------------------------------------
--to apply stimulus, we require signals for all inputs and outputs
SIGNAL asig, bsig : STD_LOGIC;
SIGNAL fsig 		: STD_LOGIC;


--3)--------------------------------------------------------
--Instantiate the DUT and bind the signals to the IOs (port map) 
BEGIN
DUT : and_gate
PORT MAP(a => asig, b	=> bsig, f => fsig);

--4) Apply the stimulus ------------------------------------
--Must wait for xx ns between applying stimulus to allow time for output to settle (Tpd)
--appropriate timing (xx ns) is determined in timing simulations
PROCESS IS
BEGIN
asig <= '0';
bsig <= '0';
wait for 20 ns;

asig <= '0';
bsig <= '1';
wait for 20 ns;

asig <= '1';
bsig <= '0';
wait for 20 ns;

asig <= '1';
bsig <= '1';
wait for 20 ns;

WAIT;

END PROCESS;


END test;

