module execute_cycle (
    input clk,
    input rst,
    input RegWriteE,
    MemtoRegE,
    MemWriteE,
    BranchE,
    ALUSrcE,
    RegDstE,
    input [31:0] ALUInFromM,
    input [31:0] ResultW,
    input [2:0] ALUControlE,
    input [31:0] RD1E,
    RD2E,
    input [1:0] ForwardAE,
    ForwardBE,
    input [4:0] RtE,
    RdE,
    input [31:0] SignImmE,
    input [31:0] PCPlus4E,
    output reg ZeroM,
    output reg [31:0] ALUOutM,
    output reg [31:0] WriteDataM,
    output reg [4:0] WriteRegM,
    output reg [31:0] PCBranchM,
    output reg RegWriteM,
    output reg MemtoRegM,
    output reg MemWriteM,
    output reg BranchM
);
  wire [31:0] _SrcBE, SrcBE, SrcAE;
  wire [31:0] WriteDataE;
  wire [4:0] WriteRegE;
  wire [31:0] PCBranchE;
  wire [31:0] ALUResultE;
  wire ZeroE;
  assign SrcAE = (ForwardAE == 2'b00) ? RD1E : (ForwardAE == 2'b01) ? ResultW : ALUInFromM;
  assign _SrcBE = (ForwardBE == 2'b00) ? RD2E : (ForwardBE == 2'b01) ? ResultW : ALUInFromM;
  assign SrcBE = (ALUSrcE == 1) ? SignImmE : _SrcBE;
  assign WriteDataE = RD2E;
  assign WriteRegE = (RegDstE == 1) ? RdE : RtE;
  assign PCBranchE = (PCPlus4E + (SignImmE << 2));


  alu ALU (
      .A(SrcAE),
      .B(SrcBE),
      .ALUControl(ALUControlE),
      .Result(ALUResultE),
      .Zero(ZeroE)
  );

  always @(posedge clk) begin
    if (rst) begin
      ZeroM <= 0;
      ALUOutM <= 0;
      WriteDataM <= 0;
      WriteRegM <= 0;
      PCBranchM <= 0;
      RegWriteM <= 0;
      MemtoRegM <= 0;
      MemWriteM <= 0;
      BranchM <= 0;
    end else begin
      ZeroM <= ZeroE;
      ALUOutM <= ALUResultE;
      WriteDataM <= WriteDataE;
      WriteRegM <= WriteRegE;
      PCBranchM <= PCBranchE;
      RegWriteM <= RegWriteE;
      MemtoRegM <= MemtoRegE;
      MemWriteM <= MemWriteE;
      BranchM <= BranchE;
    end
  end


endmodule
