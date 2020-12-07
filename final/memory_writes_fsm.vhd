LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY memory_writes_fsm IS
    PORT (
        clk, reset, hard_reset : IN STD_LOGIC;
        wwren_out : OUT STD_LOGIC;
        waddr_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        uwren_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        uaddr_out : OUT STD_LOGIC_vector(5 downto 0);
        mwf_done : OUT STD_LOGIC;
        setup : IN STD_LOGIC;
        stall : IN STD_LOGIC;
        exostate : IN t_mode_state);
END ENTITY;

ARCHITECTURE behaviour OF memory_writes_fsm IS
    SIGNAL ramLoaded : t_weight_state := none;
BEGIN

    PROCESS (clk, hard_reset) IS
    BEGIN
        IF (hard_reset = '1') THEN
            ramLoaded <= none;
            uwren_out <= "000";
            uaddr_out <= "000000";
            wwren_out <= '0';
            waddr_out <= "00";
            mwf_done <= '0';

        ELSIF (falling_edge(clk)) THEN --falling edge to align it better with the sram
            IF (stall = '0') THEN --and continue = '0'
                IF (setup = '1' AND (exostate = idle)) THEN
                    wwren_out <= '1';
                    ramLoaded <= first;
                    waddr_out <= "00";

                    uwren_out <= "111";
                    uaddr_out <= "000000";

                ELSIF (exostate = t_setup AND ramLoaded = first) THEN
                    waddr_out <= "01";
                    uaddr_out <= "010101";
                    ramLoaded <= second;
                ELSIF (exostate = t_setup AND ramLoaded = second) THEN
                    waddr_out <= "10";
                    uaddr_out <= "101010";
                    ramLoaded <= done;

                ELSIF (exostate = t_setup AND ramLoaded = done) THEN
                    waddr_out <= "00";
                    uaddr_out <= "111111";
                    wwren_out <= '0';
                    uwren_out <= "000";
                    mwf_done <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;
END behaviour;