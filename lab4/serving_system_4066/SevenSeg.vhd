LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY SevenSeg IS
    PORT (
        D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END SevenSeg;

ARCHITECTURE Behaviour OF SevenSeg IS

BEGIN

    PROCESS (D)
    begin
        CASE(D) IS

            WHEN "0000" =>
                Y <= "1000000";
            WHEN "0001" =>
                Y <= "1111001";
            WHEN "0010" =>
                Y <= "0100100";
            WHEN "0011" =>
                Y <= "0110000";
            WHEN "0100" =>
                Y <= "0011001";
            WHEN "0101" =>
                Y <= "0010010";
            WHEN "0110" =>
                Y <= "0000010";
            WHEN "0111" =>
                Y <= "1111000";
            WHEN "1000" =>
                Y <= "0000000";
            WHEN "1001" =>
                Y <= "0011000";
            WHEN OTHERS =>
                Y <= "1111111";

        END CASE;
    END PROCESS;

END Behaviour;