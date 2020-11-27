LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY matrix_multiplication_unit IS
    PORT (
        clk, reset, hard_reset, ld, ld_w, stall : IN STD_LOGIC;
        a0, a1, a2, w0, w1, w2 : IN UNSIGNED(7 DOWNTO 0);
        y0, y1, y2 : OUT UNSIGNED(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE structure OF matrix_multiplication_unit IS

    SIGNAL state : t_MMU_STATE;
    SIGNAL clksig : STD_LOGIC;

    SIGNAL ldsig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL ld_wsig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL a_insig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL w_insig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL part_insig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL a_outsig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL partial_sumsig : STD_LOGIC_VECTOR(8 DOWNTO 0);

    COMPONENT processing_element IS
        PORT (
            clk, reset, hard_reset, ld, ld_w : IN STD_LOGIC;
            a_in, w_in, part_in : IN UNSIGNED(7 DOWNTO 0);
            a_out, partial_sum : OUT UNSIGNED(7 DOWNTO 0));
    END COMPONENT;

BEGIN

    --generate the matrix of PE's
    GEN_PE : FOR i IN 0 TO 8 GENERATE
        PE : processing_element
        PORT MAP(clksig, reset, hard_reset, ldsig(i), ld_wsig(i), a_insig(i), w_insig(i), part_insig(i), a_outsig(i), partial_sumsig(i));
    END GENERATE;

    --matrix looks like this:
    --
    --0  3  6
    --1  4  7
    --2  5  8
    --

    --load weights in the first column, then second column, then third column
    ld_wsig(2 DOWNTO 0) <= "111" WHEN state = load_col0 ELSE "000";
    ld_wsig(5 DOWNTO 3) <= "111" WHEN state = load_col1 ELSE "000";
    ld_wsig(8 DOWNTO 6) <= "111" WHEN state = load_col2 ELSE "000";
    
    --apply the input weights to all elements in each row so that they can be latched by the PEs when ld_w is called
    w_insig(2 DOWNTO 0) <= (w2 & w1 & w0);
    w_insig(5 DOWNTO 3) <= (w2 & w1 & w0);
    w_insig(8 DOWNTO 6) <= (w2 & w1 & w0);

    --map the a signals to their correct locations
    a_insig(2 DOWNTO 0) <= (a2 & a1 & a0);
    a_insig(5 DOWNTO 3) <= a_outsig(2 DOWNTO 0);
    a_insig(8 DOWNTO 6) <= a_outsig(5 DOWNTO 3);
    --nothing to do with a_outsig(2 downto 0); they are left open.

    partial_aligner : for i in 0 to 2 generate
        part_insig(1 + (3*i)) <= partial_sumsig(3*i); --first row
        part_insig(2 + (3*i)) <= partial_sumsig(1 + (3*i)); --second row
    end generate;
    
    --output the partial sums of the end items
    y0 <= partial_sumsig(2);
    y1 <= partial_sumsig(5);
    y2 <= partial_sumsig(8);
    
    PROCESS (clk) IS
    BEGIN
        IF (rising_edge(clk)) THEN --only change states on rising edges
            IF (state = load_col0) THEN --iterate through the states
                state <= load_col1;
            ELSIF (state = load_col1) THEN --iterate through the states
                state <= load_col2;
            ELSIF (state = load_col2) THEN --iterate through the states
                state <= idle;
            ELSIF ((state = idle) and (ld_w = '1')) then --leaves idle state if ld_w is asserted
                state <= load_col0;
            END IF;
        END IF;
    END PROCESS;

    process(clk, stall) is 
    begin
        if (rising_edge(clk)) then
            if (stall = '0' and ld = '1') then
                ldsig(8 downto 0) <= "111111111";
            end if;
        end if;
    end process;


END structure;