LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyLib.ALL;
ENTITY Fifo_Memory IS
    GENERIC (
        ADDR_WIDTH : INTEGER := 4;
        DATA_WIDTH : INTEGER := 8
    );
    PORT (
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        wr : IN STD_LOGIC;
        rd : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        base_addr : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY Fifo_Memory;

ARCHITECTURE behavioral OF Fifo_Memory IS
    SIGNAL fifo_empty, fifo_re, fifo_full, fifo_we : STD_LOGIC;
    SIGNAL write_addr, read_addr : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0) := base_addr;
    SIGNAL Dout : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

BEGIN

    Read_Pointer_Unit : Read_Pointer
    GENERIC MAP(
        ADDR_WIDTH => ADDR_WIDTH
    )
    PORT MAP(
        clk => clk,
        rd => rd,
        fifo_empty => fifo_empty,
        base_addr => base_addr,
        fifo_re => fifo_re,
        rptr => read_addr
    );
    Write_Pointer_Unit : Write_Pointer
    GENERIC MAP(
        ADDR_WIDTH => ADDR_WIDTH
    )
    PORT MAP(
        clk => clk,
        fifo_full => fifo_full,
        base_addr => base_addr,
        wr => wr,
        wptr => write_addr,
        fifo_we => fifo_we
    );
    Memory_Array_Unit : Memory_Array
    GENERIC MAP(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH
    )
    PORT MAP(
        clk => clk,
        fifo_re => fifo_re,
        fifo_we => fifo_we,
        rptr => read_addr,
        wptr => write_addr,
        data_in => data_in,
        data_out => Dout
    );
    Status_Signal_Unit : Status_Signal
    GENERIC MAP(
        ADDR_WIDTH => ADDR_WIDTH
    )
    PORT MAP(
        clk => clk,
        fifo_we => fifo_we,
        fifo_re => fifo_re,
        wptr => write_addr,
        rptr => read_addr,
        fifo_full => fifo_full,
        fifo_empty => fifo_empty
    );
    data_out <= Dout;
END ARCHITECTURE behavioral;