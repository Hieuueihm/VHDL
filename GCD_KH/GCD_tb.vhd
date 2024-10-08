
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyLib.All;


ENTITY GCD_tb IS
  
END ENTITY;
ARCHITECTURE BEV OF GCD_tb IS
	constant DATA_WIDTH: INTEGER := 8;
	Signal CLK, RST, Start_i : STD_LOGIC;
	Signal X_i, Y_i: STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	Signal GCD_o: STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	Signal Done_o:  STD_LOGIC;
	
BEGIN
	
	UUT:  GCD 
    GENERIC MAP ( DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
        RST, CLK,
        Start_i,
        X_i, Y_i,
        GCD_o,
        Done_o
    );

-- CLOCK
CLK_sig: PROCESS
BEGIN 
	CLK <= '1';
	Wait for 1 ns;
	CLK <= '0';
	WAIT For 1 ns;
END PROCESS;
--stimulus
Stimulus: PROCESS
BEGIN
	Start_i <= '0';
	RST <= '1';
	wait for 10 ns;
	RST <= '0';
	wait for 10 ns;
	
	-- case 1 : X = 12 , Y =  4 => ucln = 4 
	X_i <= X"0C";
	Y_i <= X"04";
	Start_i <= '1';
	WAIT until Done_o = '1';
	Start_i <= '0';
	wait;


END PROCESS;

END ARCHITECTURE;