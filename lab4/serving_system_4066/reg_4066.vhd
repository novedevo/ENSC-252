ENTITY reg_4066 IS
    GENERIC (
        data_width : INTEGER := 4;
        N : INTEGER := 9);
    PORT (
        clk, reset, inc, ld : IN STD_LOGIC;
        D : IN UNSIGNED(data_width - 1 DOWNTO 0);
        Q : OUT UNSIGNED(data_width - 1 DOWNTO 0));
END reg_4066;


