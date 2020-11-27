LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processing_element IS
    PORT (
        clk, reset, hard_reset, ld, ld_w : IN STD_LOGIC;
        a_in, w_in, part_in : IN UNSIGNED(7 DOWNTO 0);
        a_out, partial_sum : OUT UNSIGNED(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE structure OF processing_element IS
    SIGNAL Asig : UNSIGNED (7 DOWNTO 0);
    SIGNAL Ysig : UNSIGNED (7 DOWNTO 0);
    SIGNAL Wsig : UNSIGNED (7 DOWNTO 0);
    SIGNAL mac : UNSIGNED (15 DOWNTO 0);
    signal rounded : UNSIGNED (7 DOWNTO 0);
BEGIN

mac <= (Wsig * a_in) + part_in;

rounded <= mac(7 downto 0) when mac(15 downto 8) = to_unsigned(0, 8) else to_unsigned(255, 8);

process (clk, reset, hard_reset)
begin
    if hard_reset = '1' then
        Asig <= to_unsigned(0, 8);
        Ysig <= to_unsigned(0, 8);
        Wsig <= to_unsigned(0, 8);
    elsif reset = '1' then
        Asig <= to_unsigned(0, 8);
        Ysig <= to_unsigned(0, 8);
    elsif rising_edge(clk) then
        Wsig <= w_in when ld_w = '1' else Wsig;
        Asig <= a_in when ld = '1' else Asig;
        Ysig <= rounded;
    end if;
end process;

a_out <= Asig;
partial_sum <= Ysig;


END structure;