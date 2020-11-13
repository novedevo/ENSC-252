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
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            code_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT box2 IS
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

    b1 : box1 PORT MAP(clk, reset, enable, code1);
    b2 : box2 PORT MAP(clk, reset, enable, code2);

    code_out <= code1 when (sel = '0') else code2;

END ARCHITECTURE;