LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.MyLib.ALL;

ENTITY I2C_Master_tb IS
END ENTITY I2C_Master_tb;

ARCHITECTURE behavior OF I2C_Master_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    -- Testbench signals
    SIGNAL CLK_tb : STD_LOGIC := '0';
    SIGNAL RST_tb : STD_LOGIC := '0';
    SIGNAL En_tb : STD_LOGIC := '0';
    SIGNAL Addr_tb : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL I2C_RW_tb : STD_LOGIC := '0';
    SIGNAL Data_wr_tb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Data_rd_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL I2C_busy_tb : STD_LOGIC;
    SIGNAL SCL_tb : STD_LOGIC;
    SIGNAL SDA_tb : STD_LOGIC := '1';

    -- Clock period definitions
    CONSTANT CLK_PERIOD : TIME := 100 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : I2C_Master
    PORT MAP(
        CLK => CLK_tb,
        RST => RST_tb,
        En => En_tb,
        Addr => Addr_tb,
        I2C_RW => I2C_RW_tb,
        Data_wr => Data_wr_tb,
        Data_rd => Data_rd_tb,
        I2C_busy => I2C_busy_tb,
        SCL => SCL_tb,
        SDA => SDA_tb
    );

    -- Clock process definitions
    CLK_PROCESS : PROCESS
    BEGIN
        CLK_tb <= '0';
        WAIT FOR CLK_PERIOD/2;
        CLK_tb <= '1';
        WAIT FOR CLK_PERIOD/2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.
        WAIT FOR 100 ns;
        RST_tb <= '0';
        WAIT FOR 100 ns;
        RST_tb <= '1';

        -- Write operation
        Addr_tb <= "1110000"; -- some address
        I2C_RW_tb <= '0'; -- write operation
        Data_wr_tb <= "11001111"; -- data to write
        En_tb <= '1';
        WAIT UNTIL I2C_busy_tb = '0'; -- wait for the operation to complete
        En_tb <= '0';

        -- Read operation
        WAIT FOR 1000 ns;
        Addr_tb <= "1010101"; -- same address
        I2C_RW_tb <= '1'; -- read operation
        En_tb <= '1';
        WAIT UNTIL I2C_busy_tb = '0';
        En_tb <= '0';
        -- insert stimulus here

        WAIT;
    END PROCESS;
END ARCHITECTURE behavior;