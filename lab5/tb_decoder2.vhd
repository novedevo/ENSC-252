LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_decoder2 IS
END ENTITY;

ARCHITECTURE test OF tb_decoder2 IS

    COMPONENT decoder IS
        GENERIC (
            morse : STD_LOGIC_VECTOR);
        PORT (
            seq : IN unsigned;
            WaveOut : OUT STD_LOGIC);
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 10 ns;
    CONSTANT PERIOD : TIME := 20 ns;

    SIGNAL sigseq : unsigned;
    SIGNAL sigwave : STD_LOGIC;

BEGIN

    DUT : decoder GENERIC MAP("11101010001000101010111000111011101110000000")
    PORT MAP(sigseq, sigwave);

    PROCESS IS
    BEGIN

        FOR i IN 43 DOWNTO 0 LOOP
            sigseq <= to_unsigned(i, 6);
            WAIT FOR HALF_PERIOD;
        END LOOP;

        WAIT;
    END PROCESS;

END ARCHITECTURE;