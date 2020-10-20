LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BCDunit IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        mode : IN STD_LOGIC;
        segOut0, segOut1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));

END BCDunit;

ARCHITECTURE Structure OF BCDunit IS

    COMPONENT bcdaddsub_4066 IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            mode : IN STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT SevenSeg IS
        PORT (
            D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
    END COMPONENT;

    SIGNAL cout : STD_LOGIC;
    SIGNAL I : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    bcdaddsub : bcdaddsub_4066
    PORT MAP(A => A, B => B, mode => mode, cout => cout, sum => I);

    SevenSeg0 : SevenSeg
    PORT MAP(D => I, Y => segOut0);

    SevenSeg1 : SevenSeg
    PORT MAP(D(3) => '0', D(2) => '0', D(1) => '0', D(0) => cout, Y => segOut1);

END Structure;