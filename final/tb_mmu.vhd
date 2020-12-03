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

signal clksig: std_logic := '0';
signal resetsig, hard_resetsig, ldsig, ld_wsig, stallsig : std_logic := '0';

signal asig, wsig: bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8)) ;
signal ysig : bus_width;

BEGIN

    clksig <= not clksig after half_period;

    DUT : matrix_multiplication_unit
    PORT MAP(
        clksig, resetsig, hard_resetsig, ldsig, ld_wsig, stallsig,
        asig(0), asig(1), asig(2), wsig(0), wsig(1), wsig(2), ysig(0), ysig(1), ysig(2));

    PROCESS IS
    BEGIN

    resetsig <= '1';
    hard_resetsig <= '1';
    wait for period;
    resetsig <= '0';
    hard_resetsig <= '0';
    wait for period;
    ld_wsig <= '1';

    wsig <= (to_unsigned(1, 8), to_unsigned(0, 8), to_unsigned(0, 8));
    wait for period;
    wsig <= (to_unsigned(0, 8), to_unsigned(1, 8), to_unsigned(0, 8));
    wait for period;
    wsig <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(1, 8));
    wait for period;
    wsig <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));
    ld_wsig <= '0';
    wait for 10*period;
    ldsig <= '1';
    asig <= (to_unsigned(1, 8), to_unsigned(0, 8), to_unsigned(0, 8));
    wait for period;
    asig <= (to_unsigned(0, 8), to_unsigned(1, 8), to_unsigned(0, 8));
    wait for period;
    asig <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(1, 8));
    wait for period;
    ldsig <= '0';
    asig <= (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));

    wait;



    END PROCESS;
END test;