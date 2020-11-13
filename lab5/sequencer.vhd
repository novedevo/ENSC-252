LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sequencer IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        count : OUT unsigned
    );
END sequencer;

ARCHITECTURE behaviour OF sequencer IS

    SIGNAL countSig : unsigned;

BEGIN
    PROCESS (reset, clk) IS
    BEGIN
        IF (reset = '1') THEN
            countSig <= to_unsigned(33, 6);
        ELSIF (rising_edge(clk)) THEN
            IF (countSig = to_unsigned(0, 6)) THEN
                countSig <= to_unsigned(33, 6);
            ELSE
                countSig <= countSig - to_unsigned(1, 6);
            END IF;
        ELSE
            countSig <= countSig;
        END IF;
    END PROCESS;

END behaviour;