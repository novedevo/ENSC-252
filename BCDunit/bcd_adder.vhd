LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bcd_adder IS
    PORT( A, B  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin     : IN STD_LOGIC;
        F       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout    : OUT STD_LOGIC);
END bcd_adder;

ARCHITECTURE Structure of bcd_adder is
    
    COMPONENT fourbitadd IS
	    PORT(A, B : IN STD_LOGIC_VECTOR(3 downto 0);
		Cin : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR(3 downto 0);
        Cout : OUT STD_LOGIC);  --technically I could change this to a buffer
                                --instead of making a new signal
    END COMPONENT;

    signal I: STD_LOGIC_VECTOR(3 downto 0);
    signal internalCout : STD_LOGIC;
    signal coutBuffer : STD_LOGIC;

    BEGIN

        InputAdder : fourbitadd
            port map (A => A, B => B, Cin => cin, S => I, Cout => internalCout);

        OutputAdder : fourbitadd
            port map (A(0) => '0', A(1) => coutBuffer, A(2) => coutBuffer, A(3) => '0', B => I, Cin => '0', S => F, Cout => open);

        coutBuffer <=   (internalCout OR 
                        (I(3) AND I(2)) OR 
                        (I(3) AND I(1)));

        Cout <= coutBuffer;

END Structure;