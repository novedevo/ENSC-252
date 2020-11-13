LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder2 IS
    PORT (
        seq : IN unsigned;
        WaveOut : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behaviour OF decoder2 IS
    CONSTANT table : STD_LOGIC_VECTOR := "11101010001000101010111000111011101110000000";
BEGIN

    WaveOut <= table(to_integer(seq) - 1);

END ARCHITECTURE;