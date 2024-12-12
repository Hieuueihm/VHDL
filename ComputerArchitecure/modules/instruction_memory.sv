module instruction_memory  (
    input [31:0] A,
    output [31:0] RD
);
  logic [31:0] ins [2047:0]; 
    
    initial begin
        $readmemh("D:\\Code\\FPGADesign\\ComputerArchitecure\\mem\\mem.dump",ins); 
    end
	 
	assign RD = ins[A];
    
endmodule