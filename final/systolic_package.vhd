-- Package Declaration Section
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE systolic_package IS
    CONSTANT N : INTEGER := 8;
    TYPE bus_width IS ARRAY (0 TO 2) OF UNSIGNED(N - 1 DOWNTO 0);
    TYPE t_MMU_STATE IS (idle, load_col0, load_col1, load_col2);
END PACKAGE systolic_package;

PACKAGE BODY systolic_package IS
    --blank, include any implementations here, if necessary
END PACKAGE BODY systolic_package;