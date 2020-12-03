LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY tb_stpu IS
END ENTITY;

ARCHITECTURE test OF tb_stpu IS

    COMPONENT stpu IS
        PORT (
            clk, reset, hard_reset, setup, GO, stall : IN STD_LOGIC;
            weights, a_in : IN UNSIGNED (23 DOWNTO 0);
            y0, y1, y2 : OUT bus_width
        );
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 5 ns;
    CONSTANT PERIOD : TIME := 10 ns;

    SIGNAL clksig : STD_LOGIC := '1';

    SIGNAL resetsig, hard_resetsig, setupsig, GOsig, stallsig : STD_LOGIC;
    SIGNAL weightsig, a_insig : unsigned (23 DOWNTO 0);
    SIGNAL y0sig, y1sig, y2sig : bus_width;

BEGIN

    DUT : stpu PORT MAP(clksig, resetsig, hard_resetsig, setupsig, GOsig, stallsig, weightsig, a_insig, y0sig, y1sig, y2sig);

    clksig <= NOT clksig AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN
        hard_resetsig <= '1';
        resetsig <= '1';
        setupsig <= '0';
        gosig <= '0';
        stallsig <= '0';
        weightsig <= to_unsigned(0, 24);
        a_insig <= to_unsigned (0, 24);
        WAIT FOR period;
        hard_resetsig <= '0';
        resetsig <= '0';
        setupsig <= '1';
        wait for period;
        setupsig <= '0';

        weightsig <= (to_unsigned(1, 8) & to_unsigned(0, 16));
        a_insig <= (to_unsigned(1, 8) & to_unsigned(0, 16));
        wait for period;
        weightsig <= (to_unsigned(0, 8) & to_unsigned(1, 8) & to_unsigned(0, 8));
        a_insig <= (to_unsigned(0, 8) & to_unsigned(1, 8) & to_unsigned(0, 8));
        wait for period;
        weightsig <= (to_unsigned(0, 16) & to_unsigned(1, 8));
        a_insig <= (to_unsigned(0, 16) & to_unsigned(1, 8));
        
        wait for 10*period;

        gosig <= '1';
        wait for period;
        gosig <= '0';
        
        
        WAIT;
    END PROCESS;
END test;