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

    SIGNAL state : t_MMU_STATE := idle;
    --SIGNAL clksig : STD_LOGIC;

    SIGNAL ldsig : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
    SIGNAL ld_wsig : STD_LOGIC_VECTOR(8 DOWNTO 0);
    SIGNAL a_insig, w_insig, part_insig, a_outsig, partial_sumsig : pe_bus;

    COMPONENT processing_element IS
        PORT (
            clk, reset, hard_reset, ld, ld_w : IN STD_LOGIC;
            a_in, w_in, part_in : IN UNSIGNED(7 DOWNTO 0);
            a_out, partial_sum : OUT UNSIGNED(7 DOWNTO 0));
    END COMPONENT;

    COMPONENT weight_loading_fsm IS
        PORT (
            clk, reset, hard_reset : IN STD_LOGIC;
            ld_w : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
            ld_win : IN STD_LOGIC;
            exostate : IN t_mmu_state);
    END COMPONENT;

BEGIN
    --generate the matrix of PE's
    GEN_PE : FOR i IN 0 TO 8 GENERATE
        PE : processing_element
        PORT MAP(clk, reset, hard_reset, ldsig(i), ld_wsig(i), a_insig(i), w_insig(i), part_insig(i), a_outsig(i), partial_sumsig(i));
    END GENERATE;

    wlf : weight_loading_fsm
    PORT MAP(clk, reset, hard_reset, ld_wsig, ld_w, state);

    --matrix looks like this:
    --
    --0  3  6
    --1  4  7
    --2  5  8
    --

    --apply the input weights to all elements in each row so that they can be latched by the PEs when ld_w is called
    w_insig(2 DOWNTO 0) <= (w2, w1, w0);
    w_insig(5 DOWNTO 3) <= (w2, w1, w0);
    w_insig(8 DOWNTO 6) <= (w2, w1, w0);

    --map the a signals to their correct locations
    a_insig(2 DOWNTO 0) <= (a2, a1, a0);
    a_insig(5 DOWNTO 3) <= a_outsig(2 DOWNTO 0);
    a_insig(8 DOWNTO 6) <= a_outsig(5 DOWNTO 3);
    --nothing to do with a_outsig(2 downto 0); they are left open.

    partial_aligner : FOR i IN 0 TO 2 GENERATE
        part_insig(3 * i) <= "00000000";
        part_insig(1 + (3 * i)) <= partial_sumsig(3 * i); --second row
        part_insig(2 + (3 * i)) <= partial_sumsig(1 + (3 * i)); --third row
    END GENERATE;

    --output the partial sums of the end items
    y0 <= partial_sumsig(2);
    y1 <= partial_sumsig(5);
    y2 <= partial_sumsig(8);

    PROCESS (reset, hard_reset, ld_w) IS
    BEGIN
        IF (reset = '1' OR hard_reset = '1') THEN
            state <= idle;
        ELSIF (ld_w = '1') THEN
            state <= init;
        ELSE
            state <= compute;
        END IF;
    END PROCESS;
    
    ldSig <= "111111111" when (ld = '1' and stall = '0') else "000000000";
END structure;