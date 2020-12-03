LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processing_element IS
    PORT (
        clk, reset, hard_reset, ld, ld_w : IN STD_LOGIC;
        a_in, w_in, part_in : IN UNSIGNED(7 DOWNTO 0);
        a_out, partial_sum : OUT UNSIGNED(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE structure OF processing_element IS
    --signals
    SIGNAL Asig, Ysig, Wsig, rounded : UNSIGNED (7 DOWNTO 0);
    SIGNAL mac : UNSIGNED (15 DOWNTO 0);
BEGIN

    --multiply a by the weight element, then add the previous partial sum
    mac <= (Wsig * a_in) + part_in;

    --if mac overflows, round it off to 111111
    rounded <= mac(7 DOWNTO 0) WHEN mac(15 DOWNTO 8) = to_unsigned(0, 8) ELSE
        to_unsigned(255, 8);

    PROCESS (clk, reset, hard_reset)
    BEGIN
        IF hard_reset = '1' THEN
            Asig <= to_unsigned(0, 8);
            Ysig <= to_unsigned(0, 8);
            Wsig <= to_unsigned(0, 8);
        ELSIF reset = '1' THEN
            --do not reset the weight matrix
            Asig <= to_unsigned(0, 8);
            Ysig <= to_unsigned(0, 8);
        ELSIF rising_edge(clk) THEN
            IF (ld_w = '1') THEN
                Wsig <= w_in;
            END IF;
            IF (ld = '1') THEN
                Asig <= a_in;
                Ysig <= rounded;
            END IF;

            
        END IF;

    END PROCESS;
    a_out <= Asig;
    partial_sum <= Ysig;

END structure;