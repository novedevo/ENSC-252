LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.systolic_package.ALL;

ENTITY stpu IS
    PORT (
        clk, reset, hard_reset, setup, GO, stall : IN STD_LOGIC;
        weights, a_in : IN UNSIGNED (23 DOWNTO 0);
        y0, y1, y2 : OUT bus_width
    );
END ENTITY;

ARCHITECTURE structure OF stpu IS

    --components
    COMPONENT activation_unit IS
        PORT (
            clk, reset, hard_reset, stall : IN STD_LOGIC;
            done : OUT STD_LOGIC;
            y_in0, y_in1, y_in2 : IN UNSIGNED(7 DOWNTO 0);
            row0, row1, row2 : OUT bus_width);
    END COMPONENT;

    COMPONENT matrix_multiplication_unit IS
        PORT (
            clk, reset, hard_reset, ld, ld_w, stall : IN STD_LOGIC;
            a0, a1, a2, w0, w1, w2 : IN UNSIGNED(7 DOWNTO 0);
            y0, y1, y2 : OUT UNSIGNED(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT URAM
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

    COMPONENT WRAM
        PORT (
            aclr : IN STD_LOGIC := '0';
            address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            clock : IN STD_LOGIC := '1';
            data : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
            rden : IN STD_LOGIC := '1';
            wren : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT memory_writes_fsm IS
        PORT (
            clk, reset, hard_reset : IN STD_LOGIC;
            wwren_out : OUT STD_LOGIC;
            waddr_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            uwren_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            uaddr_out : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            mwf_done : OUT STD_LOGIC;
            setup : IN STD_LOGIC;
            stall : IN STD_LOGIC;
            exostate : IN t_mode_state);
    END COMPONENT;

    --signals

    SIGNAL mode : t_MODE_STATE;
    --SIGNAL ramLoaded : t_WEIGHT_STATE;
    SIGNAL wLoaded : INTEGER RANGE 0 TO 4 := 0;
    SIGNAL aLoaded : INTEGER RANGE 0 TO 7 := 0;

    SIGNAL temp : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

    SIGNAL donesig, mmuLdSig, mmuLdWSig : STD_LOGIC;
    SIGNAL ysig, wsig : bus_width;
    SIGNAL asig : bus_width := (to_unsigned(0, 8), to_unsigned(0, 8), to_unsigned(0, 8));

    SIGNAL resetSig : STD_LOGIC;

    SIGNAL mmuStallSig : STD_LOGIC := '1';
    SIGNAL auStallSig : STD_LOGIC := '1';

    SIGNAL uwren : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL urden : STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
    SIGNAL uaddr : STD_LOGIC_VECTOR(5 DOWNTO 0) := "000000";
    SIGNAL wrden : STD_LOGIC := '1';
    SIGNAL wwren : STD_LOGIC := '0';
    SIGNAL waddr : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL uq0, uq1, uq2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL wq : STD_LOGIC_VECTOR(23 DOWNTO 0);
    SIGNAL mwf_done : STD_LOGIC := '0';
    signal mwf_uaddr : std_logic_vector(5 downto 0);
    signal mwf_waddr : std_logic_vector(1 downto 0);
    signal go_uaddr : std_logic_vector(5 downto 0) := "000000";
    signal go_waddr : std_logic_vector(1 downto 0) := "00";

BEGIN

    resetSig <= reset OR hard_reset;
    wsig <= (unsigned(wq(23 DOWNTO 16)), unsigned(wq(15 DOWNTO 8)), unsigned(wq(7 DOWNTO 0)));

    --instantiate components
    au : activation_unit
    PORT MAP(clk, reset, hard_reset, auStallSig, donesig, ysig(0), ysig(1), ysig(2), y0, y1, y2);

    mmu : matrix_multiplication_unit
    PORT MAP(clk, reset, hard_reset, mmuLdSig, mmuLdWSig, mmuStallSig, asig(0), asig(1), asig(2), wsig(0), wsig(1), wsig(2), ysig(0), ysig(1), ysig(2));

    u0 : uram
    PORT MAP(resetSig, uaddr(1 DOWNTO 0), clk, STD_LOGIC_VECTOR(a_in(23 DOWNTO 16)), urden(0), uwren(0), uq0);
    u1 : uram
    PORT MAP(resetSig, uaddr(3 DOWNTO 2), clk, STD_LOGIC_VECTOR(a_in(15 DOWNTO 8)), urden(1), uwren(1), uq1);
    u2 : uram
    PORT MAP(resetSig, uaddr(5 DOWNTO 4), clk, STD_LOGIC_VECTOR(a_in(7 DOWNTO 0)), urden(2), uwren(2), uq2);

    w : wram
    PORT MAP(hard_reset, waddr, clk, STD_LOGIC_VECTOR(weights), wrden, wwren, wq);

    mwf : memory_writes_fsm
    PORT MAP(
        clk, reset, hard_reset, wwren, mwf_waddr,
        uwren, mwf_uaddr, mwf_done, setup, stall, mode);

uaddr <= mwf_uaddr when mode = t_setup else go_uaddr;
waddr <= mwf_waddr when mode = t_setup else go_waddr;

    PROCESS (clk, reset, hard_reset) IS
    BEGIN
        IF (hard_reset = '1') THEN
            --ramLoaded <= none;
            mmuLdWSig <= '0';
            mmuLdSig <= '0';
            mode <= idle;
            --uwren <= "000";
            urden <= "111";
            --uaddr <= "000000";
            wrden <= '1';
            --wwren <= '0';
            --waddr <= "00";

        ELSIF (reset = '1') THEN
            mode <= idle;

        ELSIF (falling_edge(clk)) THEN --falling edge to align it better with the sram
            IF (stall = '0') THEN --and continue = '0'
                IF (setup = '1' AND (mode = idle)) THEN
                    mode <= t_setup;
                    --wwren <= '1';
                    --ramLoaded <= first;
                    --waddr <= "00";

                    --uwren <= "111";
                    --uaddr <= "000000";

                    --ELSIF (mode = t_setup AND ramLoaded = first) THEN
                    --waddr <= "01";
                    --uaddr <= "010101";
                    --ramLoaded <= second;
                    --ELSIF (mode = t_setup AND ramLoaded = second) THEN
                    --waddr <= "10";
                    --uaddr <= "101010";
                    --ramLoaded <= done;

                    --ELSIF (mode = t_setup AND ramLoaded = done) THEN
                    --waddr <= "00";
                    --uaddr <= "111111";
                    --wwren <= '0';
                    --uwren <= "000";
                    --mode <= idle;
                ELSIF (mwf_done = '1' AND mode = t_setup and go = '0') THEN
                    mode <= idle;
                

                elsIF (go = '1' AND (mode = idle or mwf_done = '1')) THEN
                    mode <= t_go;

                    wLoaded <= 1;
                    go_waddr <= "01"; --prep for next load
                ELSIF (mode = t_go AND wLoaded = 1) THEN
                    mmuLdWSig <= '1';

                    mmuStallSig <= '0';
                    --auStallSig <= '0';
                    wLoaded <= 2;
                    go_waddr <= "10";

                ELSIF (mode = t_go AND wLoaded = 2) THEN
                    --mmuLdWSig <= '0';
                    wLoaded <= 3;
                    go_waddr <= "11";

                    aLoaded <= 1;

                    go_uaddr <= "111100";
                ELSIF (mode = t_go AND wLoaded = 3) THEN
                    wLoaded <= 4;
                    mmuLdWSig <= '0';

                ELSIF (mode = t_go AND wLoaded = 4) THEN
                    wLoaded <= 0;
                    --aLoaded <= 1;

                END IF;

                IF (mode = t_go AND aLoaded = 1) THEN
                    aLoaded <= 2;
                    go_uaddr <= "110001";

                ELSIF (mode = t_go AND aLoaded = 2) THEN
                    aLoaded <= 3;
                    go_uaddr <= "000110";
                    aSig(0) <= unsigned(uq0);

                    asig(1) <= unsigned(uq2);
                    asig(2) <= unsigned(uq1);

                    mmuLdSig <= '1';
                ELSIF (mode = t_go AND aLoaded = 3) THEN
                    aLoaded <= 4;
                    go_uaddr <= "011011";

                    asig(0) <= unsigned(uq1);
                    asig(1) <= unsigned(uq0);

                    asig(2) <= unsigned(uq2);
                ELSIF (mode = t_go AND aLoaded = 4) THEN
                    aLoaded <= 5;
                    go_uaddr <= "101111";
                    asig(0) <= unsigned(uq2);
                    asig(1) <= unsigned(uq1);
                    asig(2) <= unsigned(uq0);
                ELSIF (mode = t_go AND aLoaded = 5) THEN
                    auStallSig <= '0';
                    aLoaded <= 6;
                    go_uaddr <= "111111";
                    asig(0) <= unsigned(uq0);
                    asig(1) <= unsigned(uq2);
                    asig(2) <= unsigned(uq1);
                ELSIF (mode = t_go AND aLoaded = 6) THEN
                    aLoaded <= 7;
                    asig(0) <= unsigned(uq1);
                    asig(1) <= unsigned(uq0);

                    asig(2) <= unsigned(uq2);
                ELSIF (mode = t_go AND aLoaded = 7) THEN
                    aLoaded <= 0;
                    asig <= (unsigned(uq0), unsigned(uq2), unsigned(uq1));
                    --mmuLdSig <= '0';

                END IF;

                IF (donesig = '1') THEN
                    mmuStallSig <= '1';
                    auStallSig <= '1';
                    mode <= idle;
                END IF;

            ELSIF (stall = '1' AND temp(2) = '0') THEN
                temp <= (mmuStallSig & auStallSig & '1');
                mmuStallSig <= '1';
                auStallSig <= '1';
                --continue <= '1';
                --wtemp <= wq; ASDASDAKJSHDGAKLSDHKAJSHD--###CONTINUE FROM HERE 
            ELSIF (stall = '0' AND temp(2) = '1') THEN
                mmuStallSig <= temp(0);
                austallsig <= temp(1);
                temp <= "000";
            END IF;
        END IF;

        --mmuStallSig <= '1' WHEN ((stall = '1') OR (mode = idle));
        --auStallSig <= '1' WHEN ((stall = '1') OR (mode = idle));
    END PROCESS;

    --asig(0) <= unsigned(uq0);
    --asig(1) <= unsigned(uq1);
    --asig(2) <= unsigned(uq2);

END structure;