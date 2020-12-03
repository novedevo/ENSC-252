LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY tb_mmu IS
END ENTITY;

ARCHITECTURE test OF tb_mmu IS

    COMPONENT matrix_multiplication_unit IS
        PORT (
            clk, reset, hard_reset, ld, ld_w, stall : IN STD_LOGIC;
            a0, a1, a2, w0, w1, w2 : IN UNSIGNED(7 DOWNTO 0);
            y0, y1, y2 : OUT UNSIGNED(7 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 5 ns;
    CONSTANT PERIOD : TIME := 10 ns;

    SIGNAL clksig : STD_LOGIC := '1';
    SIGNAL resetsig, hard_resetsig, ldsig, ld_wsig, stallsig : STD_LOGIC := '0';

    SIGNAL asig, wsig : bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
    SIGNAL ysig : bus_width;

    SIGNAL intysig, intwsig, intasig : int_bus;

BEGIN

    clksig <= NOT clksig AFTER half_period;
    DUT : matrix_multiplication_unit
    PORT MAP(
        clksig, resetsig, hard_resetsig, ldsig, ld_wsig, stallsig,
        asig(0), asig(1), asig(2), wsig(0), wsig(1), wsig(2), ysig(0), ysig(1), ysig(2));

    intysig(0) <= to_integer(ysig(0));
    intysig(1) <= to_integer(ysig(1));
    intysig(2) <= to_integer(ysig(2));

    wsig(0) <= to_unsigned(intwsig(0), 8);
    wsig(1) <= to_unsigned(intwsig(1), 8);
    wsig(2) <= to_unsigned(intwsig(2), 8);

    ysig(0) <= to_unsigned(intysig(0), 8);
    ysig(1) <= to_unsigned(intysig(1), 8);
    ysig(2) <= to_unsigned(intysig(2), 8);

    

    PROCESS IS
    BEGIN

        resetsig <= '1';
        hard_resetsig <= '1';
        WAIT FOR period;
        resetsig <= '0';
        hard_resetsig <= '0';
        WAIT FOR period;
        ld_wsig <= '1';

        intwsig <= (1,2,3);
        WAIT FOR period;
        intwsig <= (4,5,6);
        WAIT FOR period;
        intwsig <= (7,8,9);
        WAIT FOR period;
        intwsig <= (0,0,0);
        ld_wsig <= '0';
        WAIT FOR 10 * period;
        ldsig <= '1';
        intasig <= (10, 11, 12);
        WAIT FOR period;
        intasig <= (13, 14, 15);
        WAIT FOR period;
        intasig <= (16, 17, 18);
        WAIT FOR period;
        ldsig <= '0';
        intasig <= (0,0,0);

        -- wsig <= (to_unsigned(1, 8), to_unsigned(2, 8), to_unsigned(3, 8));
        -- WAIT FOR period;
        -- wsig <= (to_unsigned(4, 8), to_unsigned(5, 8), to_unsigned(6, 8));
        -- WAIT FOR period;
        -- wsig <= (to_unsigned(7, 8), to_unsigned(8, 8), to_unsigned(9, 8));
        -- WAIT FOR period;
        -- wsig <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
        -- ld_wsig <= '0';
        -- WAIT FOR 10 * period;
        -- ldsig <= '1';
        -- asig <= (to_unsigned(10, 8), to_unsigned(11, 8), to_unsigned(12, 8));
        -- WAIT FOR period;
        -- asig <= (to_unsigned(13, 8), to_unsigned(14, 8), to_unsigned(15, 8));
        -- WAIT FOR period;
        -- asig <= (to_unsigned(16, 8), to_unsigned(17, 8), to_unsigned(18, 8));
        -- WAIT FOR period;
        -- ldsig <= '0';
        -- intasig <= (0,0,0);

        WAIT;

    END PROCESS;
END test;