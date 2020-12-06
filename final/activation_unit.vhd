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

    SIGNAL state : INTEGER RANGE 0 TO 5;
    SIGNAL sigRow0, sigRow1, sigRow2 : bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));

BEGIN

    PROCESS (clk, reset, hard_reset, stall) IS
    BEGIN
        IF (hard_reset = '1' OR reset = '1') THEN
            state <= 0;

        ELSIF (rising_edge(clk) AND state = 5 AND stall = '0') THEN
            state <= 0;
        ELSIF (rising_edge(clk) AND stall = '0') THEN
            state <= state + 1;
        ELSE
            state <= state;
        END IF;

    END PROCESS;
    PROCESS (reset, hard_reset, state) IS
    BEGIN
        IF (hard_reset = '1' OR reset = '1') THEN
            sigRow0 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
            sigRow1 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
            sigRow2 <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));

        ELSIF (state = 1) THEN

            sigRow0(0) <= y_in0;
        ELSIF (state = 2) THEN
            sigRow0(1) <= y_in0;
            sigRow1(0) <= y_in1;
        ELSIF (state = 3) THEN
            sigRow0(2) <= y_in0;
            sigRow1(1) <= y_in1;
            sigRow2(0) <= y_in2;
        ELSIF (state = 4) THEN
            sigRow1(2) <= y_in1;
            sigRow2(1) <= y_in2;
        ELSIF (state = 5) THEN
            sigRow2(2) <= y_in2;
        END IF;
    END PROCESS;
    row0 <= sigRow0;
    row1 <= sigRow1;
    row2 <= sigRow2;

    done <= '1' WHEN state = 5 ELSE
        '0';
END structure;