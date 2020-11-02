LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY async_tflipflop IS
    PORT (
        clk, reset, inc, ld : IN STD_LOGIC;
        T : IN STD_LOGIC;
        Q : OUT STD_LOGIC);
END async_tflipflop;

ARCHITECTURE behaviour OF async_tflipflop IS

    SIGNAL Qsig : STD_LOGIC;

    --flipflops
    PROCESS (reset, clk) IS
    BEGIN
        IF (reset = '1') THEN
            Qsig <= 0;
        ELSIF (rising_edge(clk)) THEN
            Qsig <= not Qsig when T = '1' else Qsig;
        ELSE
            Qsig <= Qsig;
        END IF;
    END PROCESS;

    Q <= Qsig;

END behaviour