LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY activation_unit IS
    PORT (
        clk, reset, hard_reset, stall : IN STD_LOGIC;
        done : OUT STD_LOGIC;
        y_in0, y_in1, y_in2 : IN UNSIGNED(7 DOWNTO 0);
        row0, row1, row2 : OUT bus_width);
END ENTITY;

ARCHITECTURE structure OF activation_unit IS

    SIGNAL state : INTEGER RANGE 0 TO 4;
    SIGNAL sigRow0, sigRow1, sigRow2 : bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));

BEGIN

    PROCESS (clk, reset, hard_reset, stall) IS
    BEGIN
        IF (hard_reset = '1' OR reset = '1') THEN
            state <= 0;
            --sigRow0 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
            ---sigRow1 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
            --sigRow2 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
        ELSIF (rising_edge(clk) AND state = 4 and stall = '0') THEN
            state <= 0;
        ELSIF (rising_edge(clk) AND stall = '0') THEN
            state <= state + 1;
        ELSE
            state <= state;
        END IF;
    END PROCESS;

    sigRow0(0) <= y_in0 WHEN state = 0;

    sigRow0(1) <= y_in0 WHEN state = 1;
    sigRow1(0) <= y_in1 WHEN state = 1;

    sigRow0(2) <= y_in0 WHEN state = 2;
    sigRow1(1) <= y_in1 WHEN state = 2;
    sigRow2(0) <= y_in2 WHEN state = 2;

    sigRow1(2) <= y_in1 WHEN state = 3;
    sigRow2(1) <= y_in2 WHEN state = 3;

    sigRow2(2) <= y_in2 WHEN state = 4;

    done <= '1' WHEN state = 4 else '0';

    row0 <= sigRow0;
    row1 <= sigRow1;
    row2 <= sigRow2;
END structure;