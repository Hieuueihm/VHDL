LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MyLib.ALL;
ENTITY MatrixMul IS
    GENERIC (
        ADDR_WIDTH : INTEGER;
        DATA_WIDTH : INTEGER;
        ColA : INTEGER;
        RowA : INTEGER;
        ColB : INTEGER;
        RowB : INTEGER
    );
    PORT (
        -- (RowA, ColA) x (RowB, ColB)
        RST : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        Start : IN STD_LOGIC;
        Data_A : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        Data_B : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        WE_A, WE_B : IN STD_LOGIC;
        RE_A, RE_B, RE_C : IN STD_LOGIC;
        Addr_A, Addr_B, Addr_C : IN STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
        Done : OUT STD_LOGIC;
        Data_out : OUT STD_LOGIC_VECTOR(2 * DATA_WIDTH - 1 DOWNTO 0)

    );
END ENTITY MatrixMul;
ARCHITECTURE rtl OF MatrixMul IS
    SIGNAL Int_RE_A, Int_RE_B, Int_RE_C, Int_WE_C, En_k, En_i, En_j, LDI_k, LDI_j, LDI_i : STD_LOGIC;
    SIGNAL Zk, Zi, Zj, Din_C_sel : STD_LOGIC;

BEGIN

    DATAPATH_UNIT : Datapath
    GENERIC MAP(
        ADDR_WIDTH => ADDR_WIDTH,
        DATA_WIDTH => DATA_WIDTH,
        ColA => ColA,
        RowA => RowA,
        ColB => ColB,
        RowB => RowB)
    PORT MAP(
        RST => RST,
        CLK => CLK,
        Start => Start,
        Data_A => Data_A,
        Data_B => Data_B,
        WE_A => WE_A,
        WE_B => WE_B,
        RE_A => RE_A,
        RE_B => RE_B,
        RE_C => RE_C,
        Addr_A => Addr_A,
        Addr_B => Addr_B,
        Addr_C => Addr_C,
        Int_RE_A => Int_RE_A,
        Int_RE_B => Int_RE_B,
        Int_RE_C => Int_RE_C,
        Int_WE_C => Int_WE_C,
        En_k => En_k,
        En_i => En_i,
        En_j => En_j,
        LDI_k => LDI_k,
        LDI_j => LDI_j,
        LDI_i => LDI_i,
        Din_C_sel => Din_C_sel,
        Zk => Zk,
        Zi => Zi,
        Zj => Zj,
        Data_out => Data_out
    );

    CONTROL_UNIT : Controller
    PORT MAP(
        Start => Start,
        CLK => CLK,
        RST => RST,
        Int_RE_A => Int_RE_A,
        Int_RE_B => Int_RE_B,
        Int_RE_C => Int_RE_C,
        Int_WE_C => Int_WE_C,
        En_k => En_k,
        En_i => En_i,
        En_j => En_j,
        LDI_k => LDI_k,
        LDI_j => LDI_j,
        LDI_i => LDI_i,
        Din_C_sel => Din_C_sel,
        Zk => Zk
        , Zi => Zi
        , Zj => Zj,
        Done => Done
    );
END ARCHITECTURE rtl;