LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY tb_pe IS
END ENTITY;

ARCHITECTURE test OF tb_pe IS
component processing_element IS
PORT (
    clk, reset, hard_reset, ld, ld_w : IN STD_LOGIC;
    a_in, w_in, part_in : IN UNSIGNED(7 DOWNTO 0);
    a_out, partial_sum : OUT UNSIGNED(7 DOWNTO 0));
END component;

constant half_period : time := 5 ns;
constant period : time := 10 ns;

signal sigclk : std_logic := '0';
signal sigreset, sighard_reset, sigld, sigld_w : std_logic;
signal siga_in, sigw_in, sigpart_in, siga_out, sigpartial_sum : unsigned(7 downto 0);

signal intins : int_bus := (0,0,0);

BEGIN

DUT: processing_element PORT MAP(sigclk, sigreset, sighard_reset, sigld, sigld_w, siga_in, sigw_in, sigpart_in, siga_out, sigpartial_sum);

sigclk <= not sigclk after half_period;

siga_in <= to_unsigned(intins(0), 8);
sigw_in <= to_unsigned(intins(1), 8);
sigpart_in <= to_unsigned(intins(2), 8);

    PROCESS IS
    BEGIN

    sigreset <= '1';
    sighard_reset <= '1';
    sigld <= '0';
    sigld_w <= '0';
    wait for period;
    sigreset <= '0';
    sighard_reset <= '0';
    wait for period; --test stalling at zeroes
    sigld_w <= '1';
    intins <= (0,5,0);
    wait for period; --test loading weight
    sigld_w <= '0';
    sigld <= '1';
    intins <= (9,0,0);
    wait for period; --test multiplying two normal numbers
    intins <= (12,0,5);
    wait for period; -- test partial_in
    intins <= (100,0,0);
    wait for period; --test overflowing from multiplication
    intins <= (5, 0, 250); --test overflowing from partial summation
    wait for period;
    sigld <= '0';
    intins <= (100,100,100);
    wait for period; --test stalling functionality
    sigreset <= '1';
    wait for period;
    sighard_reset <= '1';
    wait for period; --test the two resets

    wait;



    END PROCESS;
END test;