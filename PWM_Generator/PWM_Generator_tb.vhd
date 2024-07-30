LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE work.MyLib.ALL;

ENTITY PWM_Generator_tb IS

END ENTITY PWM_Generator_tb;

ARCHITECTURE rtl OF PWM_Generator_tb IS
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL DUTY_INCREASE : STD_LOGIC := '0';
    SIGNAL DUTY_DECREASE : STD_LOGIC := '0';

    --Outputs
    SIGNAL PWM_OUT : STD_LOGIC;

    -- Clock period definitions
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    uut : PWM_Generator PORT MAP(
        clk => clk,
        DUTY_INCREASE => DUTY_INCREASE,
        DUTY_DECREASE => DUTY_DECREASE,
        PWM_OUT => PWM_OUT
    );
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        DUTY_INCREASE <= '0';
        DUTY_DECREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_INCREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '0';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '1';
        WAIT FOR clk_period * 10;
        DUTY_DECREASE <= '0';
        WAIT FOR clk_period * 10;

        -- insert stimulus here 

        WAIT;
    END PROCESS;

END ARCHITECTURE rtl;