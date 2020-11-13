LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder IS
    PORT (
        seq : IN unsigned;
        WaveOut : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behaviour OF decoder IS
    CONSTANT table : STD_LOGIC_VECTOR := "1010100011101110111000101010000000";
BEGIN

    WaveOut <= table(to_integer(seq));

END ARCHITECTURE;