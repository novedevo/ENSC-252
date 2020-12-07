-- Package Declaration Section
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE systolic_package IS
    CONSTANT N : INTEGER := 8;
    TYPE bus_width IS ARRAY (0 TO 2) OF UNSIGNED(N - 1 DOWNTO 0);
    type int_bus is array(0 to 2) of integer;
    type pe_bus is array (8 downto 0) of unsigned(7 downto 0);
    TYPE t_WLF_STATE IS (idle, load_col0, load_col1, load_col2);
    type t_mmu_state IS (idle, init, compute);
    type t_MODE_STATE is (idle, t_setup, t_go);
    type t_WEIGHT_STATE is (none, first, second, done);

    type utemp_bus is array(0 to 2) of bus_width;
    type wtemp_bus is array(0 to 2) of std_logic_vector(23 downto 0);
END PACKAGE systolic_package;

PACKAGE BODY systolic_package IS
    --blank, include any implementations here, if necessary
END PACKAGE BODY systolic_package;