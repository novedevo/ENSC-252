LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sequencer IS
    GENERIC (
        data_width : INTEGER := 6;
        N : INTEGER := 33);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        count : OUT unsigned(data_width-1 DOWNTO 0));
END sequencer;

ARCHITECTURE behaviour OF sequencer IS

    SIGNAL countSig : unsigned(data_width-1 DOWNTO 0);

BEGIN
    PROCESS (reset, clk) IS
    BEGIN
        IF (reset = '1') THEN
            countSig <= to_unsigned(N, data_width);
        ELSIF (rising_edge(clk)) THEN
            IF (countSig = to_unsigned(0, data_width)) THEN
                countSig <= to_unsigned(N, data_width);
            ELSE
                countSig <= countSig - to_unsigned(1, data_width);
            END IF;
        ELSE
            countSig <= countSig;
        END IF;
    END PROCESS;

count <= countSig;

END behaviour;