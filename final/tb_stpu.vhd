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

signal intweightsig : int_bus := (0,0,0);
signal intasig : int_bus := (0,0,0);

BEGIN

    DUT : stpu PORT MAP(clksig, resetsig, hard_resetsig, setupsig, GOsig, stallsig, weightsig, a_insig, y0sig, y1sig, y2sig);

    clksig <= NOT clksig AFTER HALF_PERIOD;

    weightsig(23 downto 16) <= to_unsigned(intweightsig(0), 8);
    weightsig(15 downto 8) <= to_unsigned(intweightsig(1), 8);
    weightsig(7 downto 0) <= to_unsigned(intweightsig(2), 8);

    a_insig(23 downto 16) <= to_unsigned(intasig(0), 8);
    a_insig(15 downto 8) <= to_unsigned(intasig(1), 8);
    a_insig(7 downto 0) <= to_unsigned(intasig(2), 8);

    PROCESS IS
    BEGIN
        hard_resetsig <= '1';
        resetsig <= '1';
        setupsig <= '0';
        gosig <= '0';
        stallsig <= '0';
        WAIT FOR period;

        hard_resetsig <= '0';
        resetsig <= '0';
        setupsig <= '1';
        intweightsig <= (7,2,3);
        intasig <= (1,2,3);
        wait for period;

        setupsig <= '0';
        intweightsig <= (1,2,1);
        intasig <= (1,1,1);
        wait for period;

        stallsig <= '1'; --test stalling during memory writes
        wait for 10*period;

        stallsig <= '0';
        intweightsig <= (4,5,6);
        intasig <= (4,5,2);
        wait for period;

        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        gosig <= '1';
        wait for period;

        gosig <= '0';
        wait for period;
        wait for 13*period;




        hard_resetsig <= '1'; --test reset capabilities
        wait for period;

        hard_resetsig <= '0';
        setupsig <= '1';
        intweightsig <= (7,2,3);
        intasig <= (1,2,3);
        wait for period;

        setupsig <= '0';
        intweightsig <= (1,2,1);
        intasig <= (1,1,1);
        wait for period;

        --stallsig <= '1'; --test stalling during memory writes
        --wait for 10*period;

        --stallsig <= '0';
        intweightsig <= (4,5,6);
        intasig <= (4,5,2);
        wait for period;

        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        gosig <= '1';
        wait for period;

        gosig <= '0';
        wait for period;

        hard_resetsig <= '1';
        resetsig <= '1';
        setupsig <= '0';
        gosig <= '0';
        stallsig <= '0';
        WAIT FOR period;

        hard_resetsig <= '0';
        resetsig <= '0';
        setupsig <= '1';
        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        setupsig <= '0';
        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        stallsig <= '1'; --test stalling during memory writes
        wait for 10*period;

        stallsig <= '0';
        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        gosig <= '1';
        wait for period;

        gosig <= '0';
        wait for period;
        wait for 13*period;

        hard_resetsig <= '1';
        resetsig <= '1';
        setupsig <= '0';
        gosig <= '0';
        stallsig <= '0';
        WAIT FOR period;

        hard_resetsig <= '0';
        resetsig <= '0';
        setupsig <= '1';
        intweightsig <= (7,2,3);
        intasig <= (1,2,3);
        wait for period;

        setupsig <= '0';
        intweightsig <= (1,2,1);
        intasig <= (1,1,1);
        wait for period;

        stallsig <= '1'; --test stalling during memory writes
        wait for 10*period;

        stallsig <= '0';
        intweightsig <= (4,5,6);
        intasig <= (99,99,99);
        wait for period;

        intweightsig <= (0,0,0);
        intasig <= (0,0,0);
        wait for period;

        gosig <= '1';
        wait for period;

        gosig <= '0';
        wait for period;
        wait for 13*period;
        
        WAIT;
    END PROCESS;
END test;