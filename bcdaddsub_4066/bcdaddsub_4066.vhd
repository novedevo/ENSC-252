LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bcdaddsub_4066 IS
    PORT( A, B  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        mode     : IN STD_LOGIC;
        F       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout    : OUT STD_LOGIC);
END bcdaddsub_4066;



ARCHITECTURE Structure of bcdaddsub_4066 is
    
    COMPONENT nineComp IS
    PORT( X     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          mode  : IN STD_LOGIC;
          Y     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

    COMPONENT bcd_adder IS
    PORT( A, B  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        cin     : IN STD_LOGIC;
        F       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        cout    : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL I : STD_LOGIC_VECTOR(3 DOWNTO 0);

    BEGIN

        ninesCompObj : nineComp
            port map (X => B, mode => mode, Y => I);

        adderObj : bcd_adder
            port map (A => A, B => I, F => F, cout => cout, cin => mode);

END Structure;