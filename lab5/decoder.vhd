LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder IS
    GENERIC (
        morse : STD_LOGIC_VECTOR
    );
    PORT (
        seq : IN unsigned;
        WaveOut : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE behaviour OF decoder IS
BEGIN
    WaveOut <= morse(to_integer(seq));
END ARCHITECTURE;