LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_4066 IS
    GENERIC (
        data_width : INTEGER := 4;
        N : INTEGER := 9);
    PORT (
        clk, reset, inc, ld : IN STD_LOGIC;
        D : IN UNSIGNED(data_width - 1 DOWNTO 0);
        Q : OUT UNSIGNED(data_width - 1 DOWNTO 0));
END reg_4066;

ARCHITECTURE behaviour OF reg_4066 IS

    --signals
    SIGNAL Qsig : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL muxOut0 : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL muxOut1 : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL muxOut2 : unsigned(data_width - 1 DOWNTO 0);

BEGIN
    --first muxer
    muxOut0 <= (Qsig + to_unsigned(1, data_width)) WHEN (inc = '1') ELSE
        Qsig;

    --second muxer, equality checker, and and gate
    muxOut1 <= to_unsigned(0, data_width) WHEN (to_unsigned(N, data_width) = Qsig AND inc = '1') ELSE
        muxOut0;

    --third muxer
    muxOut2 <= (D) WHEN (ld = '1') ELSE
        muxOut1;

    --flipflops
    PROCESS (reset, clk) IS
    BEGIN
        IF (reset = '1') THEN
            Qsig <= to_unsigned(0, data_width);
        ELSIF (rising_edge(clk)) THEN
            Qsig <= muxOut2;
        ELSE
            Qsig <= Qsig;
        END IF;
    END PROCESS;

    Q <= Qsig;

END behaviour;