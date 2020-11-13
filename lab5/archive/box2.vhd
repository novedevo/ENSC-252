LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY box2 IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        code_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE structural OF box2 IS

    COMPONENT sequencer2 IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            count : OUT unsigned
        );
    END COMPONENT;

    COMPONENT decoder2 IS
        PORT (
            seq : IN unsigned;
            WaveOut : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL countSig : unsigned;
    SIGNAL waveSig : STD_LOGIC;

BEGIN

sequ : sequencer2 port map (clk, reset, countSig);
dec : decoder2 port map (countSig, waveSig);

code_out <= waveSig when (enable = '1') else 0;

END ARCHITECTURE;