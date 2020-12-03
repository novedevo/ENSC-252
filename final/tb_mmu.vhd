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

    signal row_1, row_2, row_3, wrow_1, wrow_2, wrow_3 : int_bus;

    SIGNAL clksig : STD_LOGIC := '1';
    SIGNAL resetsig, hard_resetsig, ldsig, ld_wsig, stallsig : STD_LOGIC := '0';

    SIGNAL asig, wsig : bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
    SIGNAL ysig : bus_width;

    SIGNAL intysig, intwsig, intasig : int_bus;

BEGIN

    wrow_1 <= (2,3,4);
    wrow_2 <= (5,6,7);
    wrow_3 <= (8,9,10);

    row_1 <= (2,2,3);
    row_2 <= (4,5,6);
    row_3 <= (7,8,9);

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

    asig(0) <= to_unsigned(intasig(0), 8);
    asig(1) <= to_unsigned(intasig(1), 8);
    asig(2) <= to_unsigned(intasig(2), 8);


    PROCESS IS
    BEGIN

        resetsig <= '1';
        hard_resetsig <= '1';
        intasig <= (0,0,0);
        WAIT FOR period;
        resetsig <= '0';
        hard_resetsig <= '0';
        WAIT FOR period;
        ld_wsig <= '1';

        -- intwsig <= (wrow_1(0), wrow_2(0), wrow_3(0));
        -- WAIT FOR period;
        -- intwsig <= (wrow_1(1), wrow_2(1), wrow_3(1));
        -- WAIT FOR period;
        -- intwsig <= (wrow_1(2), wrow_2(2), wrow_3(2));

        intwsig <= wrow_1;
        wait for period;
        intwsig <= wrow_2;
        wait for period;
        intwsig <= wrow_3;
        WAIT FOR period;
        intwsig <= (0,0,0);
        ld_wsig <= '0';
        WAIT FOR 10 * period;
        ldsig <= '1';
        intasig <= (row_1(0), 0, 0);
        WAIT FOR period;
        intasig <= (row_1(1), row_2(0), 0);
        WAIT FOR period;
        intasig <= (row_1(2), row_2(1), row_3(0));
        WAIT FOR period;
        intasig <= (0, row_2(2), row_3(1));
        WAIT FOR period;
        intasig <= (0,0,row_3(2));
        WAIT FOR period;
        --ldsig <= '0';
        intasig <= (0,0,0);

        WAIT;

    END PROCESS;
END test;