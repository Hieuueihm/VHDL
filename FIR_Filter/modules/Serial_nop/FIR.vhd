LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY FIR IS
    GENERIC (
        FILTER_TAPS : INTEGER := 11;
        INPUT_WIDTH : INTEGER RANGE 8 TO 32 := 8;
        COEF_WIDTH : INTEGER RANGE 8 TO 32 := 8;
        OUTPUT_WIDTH : INTEGER RANGE 8 TO 32 := 16 -- <COEF_WIDTH + INPUT_WIDTH - 1>
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Din : IN STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR(OUTPUT_WIDTH - 1 DOWNTO 0)
    );
END ENTITY FIR;

ARCHITECTURE Behavioral OF FIR IS
    TYPE input_registers IS ARRAY(0 TO FILTER_TAPS - 1) OF signed(INPUT_WIDTH - 1 DOWNTO 0);
    SIGNAL delay_line_s : input_registers := (OTHERS => (OTHERS => '0'));

    TYPE COEFFICIENT_TYPE IS ARRAY (0 TO FILTER_TAPS - 1) OF signed(COEF_WIDTH - 1 DOWNTO 0);
    CONSTANT coefficients : COEFFICIENT_TYPE :=
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
    TYPE FSM IS (IDLE, ACTIVE);
    SIGNAL STATE : FSM;
    SIGNAL accumulator : signed(INPUT_WIDTH + COEF_WIDTH - 1 DOWNTO 0);
    SIGNAL current_tap : INTEGER RANGE 0 TO FILTER_TAPS - 1;

BEGIN

    Dout <= STD_LOGIC_VECTOR(accumulator(OUTPUT_WIDTH - 1 DOWNTO 0));
    FIRProcess : PROCESS (clk, rst)
        VARIABLE sum : signed(OUTPUT_WIDTH - 1 DOWNTO 0);
    BEGIN
        IF rst = '1' THEN
            accumulator <= (OTHERS => '0');
            sum := (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            REPORT "Din(" & INTEGER'IMAGE(0) & ") = " & INTEGER'IMAGE(to_integer(signed(Din(INPUT_WIDTH - 1 DOWNTO 0))));
            CASE STATE IS
                WHEN IDLE =>
                    STATE <= ACTIVE;
                    current_tap <= FILTER_TAPS - 1;
                    delay_line_s(FILTER_TAPS - 1) <= signed(Din);
                WHEN ACTIVE =>
                    IF current_tap > 0 THEN
                        sum := delay_line_s(current_tap) * coefficients(current_tap);
                        accumulator <= accumulator + sum;
                        delay_line_s(current_tap - 1) <= delay_line_s(current_tap);
                        current_tap <= current_tap - 1;
                        REPORT "accumalator(" & INTEGER'IMAGE(current_tap) & ") = " & INTEGER'IMAGE(to_integer(accumulator));
                        REPORT "sum(" & INTEGER'IMAGE(current_tap) & ") = " & INTEGER'IMAGE(to_integer(sum));
                        REPORT "delay_line_s(" & INTEGER'IMAGE(current_tap) & ") = " & INTEGER'IMAGE(to_integer(delay_line_s(current_tap)));
                    ELSE
                        STATE <= IDLE;
                    END IF;
                WHEN OTHERS => STATE <= IDLE;
            END CASE;

        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;