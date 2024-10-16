LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;
ENTITY FIR_Filter IS

    GENERIC (
        DATA_INPUT_WIDTH : INTEGER := 8;
        COEF_WIDTH : INTEGER := 8;
        DATA_OUTPUT_WIDTH : INTEGER := 16;
        TAP : INTEGER := 11;
        GUARD : INTEGER := 0
    );
    PORT (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        Din : IN STD_LOGIC_VECTOR(DATA_INPUT_WIDTH - 1 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(DATA_OUTPUT_WIDTH - 1 DOWNTO 0)

    );
END ENTITY FIR_Filter;

ARCHITECTURE rtl OF FIR_Filter IS
    -- COMPONENT of Register n bit
    COMPONENT Regn IS
        GENERIC (DATA_WIDTH : INTEGER);
        PORT (
            RST, CLK : IN STD_LOGIC;
            D : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;
    -- TAP VECTOR output (1 to 11 ), 8 bit 
    TYPE Coeficient_type IS ARRAY (0 TO TAP - 1) OF STD_LOGIC_VECTOR(COEF_WIDTH - 1 DOWNTO 0);
    CONSTANT coeficient : coeficient_type :=
    (X"F1",
    X"F3",
    X"07",
    X"26",
    X"42",
    X"4E",
    X"42",
    X"26",
    X"07",
    X"F3",
    X"F1"
    );
    TYPE shift_reg_type IS ARRAY (0 TO tap - 1) OF STD_LOGIC_VECTOR(DATA_INPUT_WIDTH - 1 DOWNTO 0);
    SIGNAL shift_reg : shift_reg_type; -- SHIFT REGISTER 
    TYPE mult_type IS ARRAY (0 TO tap - 1) OF STD_LOGIC_VECTOR(DATA_INPUT_WIDTH + COEF_WIDTH - 1 DOWNTO 0);
    SIGNAL mult : mult_type; -- COEF * TAP
    TYPE ADD_type IS ARRAY (0 TO tap - 1) OF STD_LOGIC_VECTOR(DATA_INPUT_WIDTH + COEF_WIDTH - 1 DOWNTO 0);
    SIGNAL ADD : ADD_type; -- ADD RESULTS 

BEGIN

    shift_reg(0) <= Din;
    ADD(0) <= shift_reg(0) * coeficient(0);
    GEN_FIR :
    FOR i IN 0 TO tap - 2 GENERATE -- 1 -> 11 = 0 -> 
    BEGIN
        -- rising_edge clk -> shift(i + 1) = shift(i)
        N_bit_Reg_unit : Regn GENERIC MAP(DATA_WIDTH => 8)
        PORT MAP(
            Clk => Clk,
            RST => RST,
            D => shift_reg(i),
            Q => shift_reg(i + 1)
        );
        mult(i + 1) <= shift_reg(i + 1) * coeficient(i + 1);
        ADD(i + 1) <= ADD(i) + mult(i + 1);
    END GENERATE;
    Dout <= ADD(tap - 2);

END ARCHITECTURE;