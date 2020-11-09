LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter_chain IS
    GENERIC (
        radix : INTEGER := 9;
        data_width : INTEGER := 4);
    PORT (
        clk, reset, take_number : IN STD_LOGIC;
        rollback : IN STD_LOGIC;
        number : OUT UNSIGNED((3 * data_width) - 1 DOWNTO 0));
END counter_chain;

ARCHITECTURE structure OF counter_chain IS

    --components
    COMPONENT increment_control_unit IS
        GENERIC (
            N : INTEGER := 9;
            data_width : INTEGER := 4);
        PORT (
            clk, reset : IN STD_LOGIC;
            incr, rollback : IN STD_LOGIC; --generates next number, rollback decrements
            flag, flag_back : OUT STD_LOGIC;
            q : OUT UNSIGNED(data_width - 1 DOWNTO 0)); --output value
    END COMPONENT;

    --signals
    SIGNAL incrSig0 : STD_LOGIC;
    SIGNAL incrSig1 : STD_LOGIC;
    SIGNAL incrSig2 : STD_LOGIC;

    SIGNAL rollbackSig0 : STD_LOGIC;
    SIGNAL rollbackSig1 : STD_LOGIC;
    SIGNAL rollbackSig2 : STD_LOGIC;

    SIGNAL flagSig0 : STD_LOGIC;
    SIGNAL flagSig1 : STD_LOGIC;
    SIGNAL flagSig2 : STD_LOGIC;

    SIGNAL flagBackSig0 : STD_LOGIC;
    SIGNAL flagBackSig1 : STD_LOGIC;
    SIGNAL flagBackSig2 : STD_LOGIC;

    SIGNAL digit0 : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL digit1 : unsigned(data_width - 1 DOWNTO 0);
    SIGNAL digit2 : unsigned(data_width - 1 DOWNTO 0);

    SIGNAL numberSig : UNSIGNED((3 * data_width) - 1 DOWNTO 0);

BEGIN

    numberSig <= (digit2 & digit1 & digit0); --concatenate, hundreds then tens then ones
    number <= numberSig;

    --instantiate components
    ICU0 : increment_control_unit GENERIC MAP(radix, data_width)
    PORT MAP(
        clk => clk, reset => reset, incr => incrSig0, rollback => rollbackSig0,
        flag => flagSig0, flag_back => flagBackSig0, q => digit0);

    ICU1 : increment_control_unit GENERIC MAP(radix, data_width)
    PORT MAP(
        clk => clk, reset => reset, incr => incrSig1, rollback => rollbackSig1,
        flag => flagSig1, flag_back => flagBackSig1, q => digit1);

    ICU2 : increment_control_unit GENERIC MAP(radix, data_width)
    PORT MAP(
        clk => clk, reset => reset, incr => incrSig2, rollback => rollbackSig2,
        flag => flagSig2, flag_back => flagBackSig2, q => digit2);

    incrSig0 <= (take_number or flagSig2);

    incrSig1 <= flagSig0;

    incrSig2 <= flagSig1;

    
    rollBackSig0 <= '1' when ((rollback = '1') and (numberSig /= 0)) else '0';
    
    rollBackSig1 <= '1' when ((flagBackSig0 = '1') and (numberSig /= 0)) else '0';

    rollBackSig2 <= '1' when ((flagBackSig1 = '1') and (numberSig /= 0)) else '0';

END structure;