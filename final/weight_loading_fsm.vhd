LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY weight_loading_fsm IS
    PORT (
        clk, reset, hard_reset : IN STD_LOGIC;
        ld_w : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        ld_win : IN STD_LOGIC;
        exostate : IN t_mmu_state);
END ENTITY;

ARCHITECTURE behaviour OF weight_loading_fsm IS
    SIGNAL state : t_wlf_state := idle;
    SIGNAL resets : STD_LOGIC;
BEGIN

    resets <= (reset OR hard_reset);

    PROCESS (reset, hard_reset, clk) IS
    BEGIN
        IF (reset = '1' OR hard_reset = '1') THEN
            state <= idle;
        ELSIF (rising_edge(clk)) THEN
            CASE state IS
                WHEN idle =>
                    IF (exostate = init AND ld_win = '1') THEN
                        state <= load_col0;
                    END IF;
                WHEN load_col0 =>
                    state <= load_col1;
                WHEN load_col1 =>
                    state <= load_col2;
                WHEN load_col2 =>
                    state <= idle;
            END CASE;
        END IF;
    END PROCESS;

    PROCESS (state) IS
    BEGIN
        CASE state IS
            WHEN idle =>
                IF (exostate = init AND ld_win = '1') THEN
                    ld_w <= "111000000";
                else ld_w <= "000000000";
                END IF;
            WHEN load_col0 =>
                ld_w <= "000111000";
            WHEN load_col1 =>
                ld_w <= "000000111";
            WHEN load_col2 =>
                ld_w <= "000000000";
        END CASE;
    END PROCESS;
END behaviour;