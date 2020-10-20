LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nineComp IS
    PORT( X     : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          mode  : IN STD_LOGIC;
          Y     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END nineComp;

ARCHITECTURE Behaviour of nineComp is

BEGIN

process (mode, X)
begin
    if (mode = '0') then
        Y <= X;
    else
        Y(0) <= (not X(0));
        Y(1) <= X(1);
        Y(2) <= (not X(3) and (X(2) xor X(1)));
        Y(3) <= (not X(3) and not X(2) and not X(1));
    end if;
end process;

END Behaviour;