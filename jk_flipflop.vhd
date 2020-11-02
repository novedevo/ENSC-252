LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY async_tflipflop IS
    PORT (
        clk, reset: IN STD_LOGIC;
        J,K : IN STD_LOGIC;
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
            Qsig <= 1 when (J = '1') and (K = '0');
            Qsig <= 0 when (J = '0') and (K = '1');
            Qsig <= not Qsig when (J = '1') and (K = '1');
        ELSE
            Qsig <= Qsig;
        END IF;
    END PROCESS;

    Q <= Qsig;

END behaviour