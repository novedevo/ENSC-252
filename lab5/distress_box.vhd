LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY distress_box IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        code_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE structural OF distress_box IS

    COMPONENT box1 IS
        GENERIC (
            data_width : INTEGER := 6;
            N : INTEGER := 33;
            morse : STD_LOGIC_VECTOR
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            code_out : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL code1 : STD_LOGIC;
    SIGNAL code2 : STD_LOGIC;

BEGIN

    b1 : box GENERIC MAP(6, 33, "1010100011101110111000101010000000")
    PORT MAP(clk, reset, enable, code1);
    b2 : box GENERIC MAP(6, 43, "11101010001000101010111000111011101110000000")
    PORT MAP(clk, reset, enable, code2);

    code_out <= code1 WHEN (sel = '0') ELSE
        code2;

END ARCHITECTURE;