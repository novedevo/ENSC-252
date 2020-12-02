LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY tb_sram IS
END ENTITY;

ARCHITECTURE test OF tb_sram IS

    COMPONENT URAM IS
        PORT (
            aclr : IN STD_LOGIC := '0';
            address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            clock : IN STD_LOGIC := '1';
            data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            rden : IN STD_LOGIC := '1';
            wren : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    CONSTANT HALF_PERIOD : TIME := 5 ns;
    CONSTANT PERIOD : TIME := 10 ns;

    signal uclk : STD_LOGIC := '0';
    SIGNAL uclr, urden, uwren : STD_LOGIC;
    SIGNAL uaddr : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL uq, udata : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    DUT : uram PORT MAP(uclr, uaddr, uclk, udata, urden, uwren, uq);

    uclk <= NOT uclk AFTER HALF_PERIOD;

    PROCESS IS
    BEGIN

        uclr <= '1';
        uwren <= '0';
        urden <= '1';
        WAIT FOR period;
        uclr <= '0';

        uaddr <= "00";
        uwren <= '1';
        udata <= "10101010";
        WAIT FOR period;

        uwren <= '0';
        urden <= '1';
        WAIT;

    END PROCESS;
END test;