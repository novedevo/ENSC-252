LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY serving_system IS
    GENERIC (
        radix : INTEGER := 9;
        data_width : INTEGER := 4);
    PORT (
        clk, reset, take_number : IN STD_LOGIC;
        rollback : IN STD_LOGIC;
        bcd0, bcd1, bcd2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END serving_system;

ARCHITECTURE structure OF serving_system IS

    --components
    COMPONENT SevenSeg IS
        PORT (
            D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;

    COMPONENT counter_chain IS
        GENERIC (
            radix : INTEGER := 9;
            data_width : INTEGER := 4);
        PORT (
            clk, reset, take_number : IN STD_LOGIC;
            rollback : IN STD_LOGIC;
            number : OUT UNSIGNED((3 * data_width) - 1 DOWNTO 0));
    END COMPONENT;

    --signals
    SIGNAL dSig : UNSIGNED((3 * data_width) - 1 DOWNTO 0);
    SIGNAL vectorDSig: std_logic_vector ((3 * data_width) - 1 DOWNTO 0);

BEGIN

    vectorDSig <= STD_LOGIC_VECTOR(dSig);

    counter : counter_chain GENERIC MAP(radix, data_width)
    PORT MAP(clk, reset, take_number, rollback, dSig);

    seg0 : SevenSeg PORT MAP(vectorDSig(0 : (data_width - 1)), bcd0);
    seg0 : SevenSeg PORT MAP(vectorDSig(data_width : (2*data_width - 1)), bcd1);
    seg0 : SevenSeg PORT MAP(vectorDSig(2*data_width : (3*data_width - 1)), bcd2);

    
END structure;