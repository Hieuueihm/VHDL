LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Write_Pointer_tb IS
END ENTITY Write_Pointer_tb;
USE work.MyLib.ALL;
ARCHITECTURE behavior OF Write_Pointer_tb IS

    -- Inputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL fifo_full : STD_LOGIC := '0';
    SIGNAL wr : STD_LOGIC := '0';
    SIGNAL base_addr : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL fifo_full : STD_LOGIC;
SIGNAL fifo_empty: STD_LOGIC;
    SIGNAL wptr : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL fifo_we : STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : Write_Pointer PORT MAP(
        clk => clk,
        wr => wr,
	fifo_empty => fifo_empty,
        fifo_full => fifo_full,
        base_addr => base_addr,
        wptr => wptr,
        fifo_we => fifo_we
    );

    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process    stim_proc : PROCESS
BEGIN
    -- Initialize Inputs
    fifo_full <= '0';
    wr <= '0';
    base_addr <= "0000";

    -- Wait for global reset
    WAIT FOR 20 ns;

    -- Test Case 1: Write when not full
    wr <= '1';
    WAIT FOR 20 ns;

    -- Test Case 2: Stop writing
    wr <= '0';
    WAIT FOR 20 ns;

    -- Test Case 3: Write again
    wr <= '1';
    WAIT FOR 20 ns;

    -- Test Case 4: FIFO is full
    fifo_full <= '1';
    WAIT FOR 20 ns;

    -- Test Case 5: FIFO not full and writing resumes
    fifo_full <= '0';
    WAIT FOR 20 ns;

    -- Test finished, stop simulation
    WAIT;
END PROCESS;

END ARCHITECTURE behavior;