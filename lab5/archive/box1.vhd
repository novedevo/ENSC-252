LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY box IS
    GENERIC (
        data_width : INTEGER := 6;
        N : INTEGER := 33;
        morse : STD_LOGIC_VECTOR);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        code_out : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE structural OF box IS

    COMPONENT sequencer IS
        GENERIC (
            data_width : INTEGER := 6;
            N : INTEGER := 33);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            count : OUT unsigned);
    END COMPONENT;

    COMPONENT decoder IS
        GENERIC (
            morse : STD_LOGIC_VECTOR);
        PORT (
            seq : IN unsigned;
            WaveOut : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL countSig : unsigned;
    SIGNAL waveSig : STD_LOGIC;

BEGIN

    sequ : sequencer GENERIC MAP(data_width, N)
    PORT MAP(clk, reset, countSig);
    dec : decoder GENERIC MAP(morse)
    PORT MAP(countSig, waveSig);

    code_out <= waveSig WHEN (enable = '1') ELSE
        0;

END ARCHITECTURE;