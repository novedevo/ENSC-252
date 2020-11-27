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

SIGNAL state: integer range 0 to 9;
signal sigRow0 : bus_width;
signal sigRow1 : bus_width;
signal sigRow2 : bus_width;

BEGIN

    PROCESS (clk, reset, hard_reset, stall)
    BEGIN
        IF (hard_reset = '1' or reset = '1') THEN
            state <= 0;
        ELSIF (rising_edge(clk) and stall = '0') THEN
            state <= state + 1;
        else
            state <= state;
        END IF;
    END PROCESS;

    sigRow0(0) <= y_in0 when state = 4;

    sigRow0(1) <= y_in1 when state = 5;
    sigRow1(0) <= y_in0 when state = 5;

    sigRow0(2) <= y_in2 when state = 6;
    sigRow1(1) <= y_in1 when state = 6;
    sigRow2(0) <= y_in0 when state = 6;

    sigRow1(2) <= y_in2 when state = 7;
    sigRow2(1) <= y_in1 when state = 7;

    sigRow2(2) <= y_in0 when state = 8;

    done <= '1' when state = 9;

    row0 <= sigRow0;
    row1 <= sigRow1;
    row2 <= sigRow2;


END structure;