LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-- single byte read/write
ENTITY I2C_Master IS
    GENERIC (
        SYSTEM_CLK : INTEGER := 10_000_000;
        BUS_CLK : INTEGER := 400_000 -- FAST MODE
    );
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        En : IN STD_LOGIC;
        Addr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        I2C_RW : IN STD_LOGIC; -- 0: WRITE 1: READ
        Data_wr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_rd : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        I2C_busy : OUT STD_LOGIC;
        SCL : OUT STD_LOGIC;
        SDA : INOUT STD_LOGIC
    );
END ENTITY I2C_Master;

ARCHITECTURE rtl OF I2C_Master IS

    CONSTANT DIVIDER : INTEGER := (SYSTEM_CLK / (BUS_CLK * 4)); -- fsys / (fscl * 4)

    TYPE MACHINE IS (IDLE, START, WRITE_DATA, READ_DATA, READ_ADDR, WDATA, STOP_S);
    SIGNAL STATE : MACHINE;
    SIGNAL data_clk_prev, data_clk : STD_LOGIC;
    SIGNAL scl_clk : STD_LOGIC; --internal SCL
    SIGNAL scl_en : STD_LOGIC; -- ENABLE SCL TO OUTPUT
    SIGNAL bit_cnt : INTEGER;
    SIGNAL data_tx, data_rx : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL addr_int : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    -- internal clock generation
    PROCESS (CLK, RST)
        VARIABLE count : INTEGER RANGE 0 TO DIVIDER * 4;
    BEGIN
        IF (RST = '0') THEN
            count := 0;
        ELSIF rising_edge(clk) THEN
            data_clk_prev <= data_clk;
            IF (count = DIVIDER * 4 - 1) THEN
                count := 0;
            ELSE
                count := count + 1;
            END IF;
        END IF;

        CASE count IS
            WHEN 0 TO DIVIDER - 1 =>
                scl_clk <= '0';
                data_clk <= '0';
            WHEN DIVIDER TO DIVIDER * 2 - 1 =>
                scl_clk <= '0';
                data_clk <= '1';
            WHEN DIVIDER * 2 TO DIVIDER * 3 - 1 =>
                scl_clk <= '1';
                data_clk <= '1';
            WHEN OTHERS =>
                scl_clk <= '1';
                data_clk <= '0';
        END CASE;
    END PROCESS;

    --
    PROCESS (CLK, RST)
    BEGIN
        IF (RST = '0') THEN
            STATE <= IDLE;
            I2C_busy <= '1';
            scl_en <= '0';
            SDA <= '1';
            bit_cnt <= 7;
            Data_rd <= "00000000";
        ELSIF rising_edge(clk) THEN
            -- RISING EDGE DATA_CLK
            IF (data_clk = '1' AND data_clk_prev = '0') THEN
                CASE STATE IS
                    WHEN IDLE =>
                        SDA <= '1';
                        IF (En = '1') THEN
                            I2C_busy <= '1';
                            SDA <= '0';
                            addr_int <= Addr & I2C_RW;
                            data_tx <= data_wr;
                            STATE <= START;
                        ELSE
                            I2C_busy <= '0';
                            STATE <= IDLE;
                        END IF;
                    WHEN START =>
                        I2C_busy <= '1';
                        bit_cnt <= 7;
                        STATE <= READ_ADDR;
                    WHEN READ_ADDR =>
                        IF (bit_cnt = 0) THEN
                            SDA <= '1';
                            bit_cnt <= 7;
                            STATE <= WDATA;
                        ELSE
                            SDA <= addr_int(bit_cnt);
                            bit_cnt <= bit_cnt - 1;
                            STATE <= READ_ADDR;
                        END IF;
                    WHEN WDATA =>
                        IF (addr_int(0) = '0') THEN
                            STATE <= WRITE_DATA;
                        ELSE
                            STATE <= READ_DATA;
                        END IF;
                    WHEN WRITE_DATA =>
                        I2C_busy <= '1';
                        IF (bit_cnt = 0) THEN
                            SDA <= '1';
                            bit_cnt <= 7;
                            STATE <= STOP_S;
                        ELSE
                            bit_cnt <= bit_cnt - 1;
                            SDA <= data_tx(bit_cnt);
                            STATE <= WRITE_DATA;
                        END IF;
                    WHEN READ_DATA =>
                        I2C_busy <= '1';
                        IF (bit_cnt = 0) THEN
                            SDA <= '1';
                            bit_cnt <= 7;
                            data_rd <= data_rx;
                            STATE <= STOP_S;
                        ELSE
                            bit_cnt <= bit_cnt - 1;
                            state <= READ_DATA;
                        END IF;
                    WHEN STOP_S =>
                        STATE <= IDLE;
                        I2C_busy <= '0';
                END CASE;
            ELSIF (data_clk = '0' AND data_clk_prev = '1') THEN
                CASE STATE IS
                    WHEN START =>
                        IF (scl_en = '0') THEN
                            scl_en <= '1';
                        END IF;
                    WHEN READ_DATA =>
                        data_rx(bit_cnt) <= SDA;
                    WHEN STOP_S =>
                        scl_en <= '0';
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;

        END IF;
    END PROCESS;
    SCL <= '0' WHEN (scl_en = '1' AND scl_clk = '0') ELSE
        '1';
END ARCHITECTURE rtl;