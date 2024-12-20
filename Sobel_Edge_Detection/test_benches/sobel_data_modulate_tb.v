`timescale 1ns / 1ps



`define clk_period 10


module sobel_data_modulate_tb ();

  reg clk, rst, done_i;
  reg [7:0] d0_i, d1_i, d2_i;

  wire [7:0] d0_o, d1_o, d2_o, d3_o, d4_o, d5_o, d6_o, d7_o, d8_o;
  wire done_o;


  initial clk = 1'b1;
  always #(`clk_period / 2) clk = ~clk;
  sobel_data_modulate #(
      .ROWS(5),
      .COLS(6)
  ) uut (
      .clk(clk),
      .rst(rst),
      .d0_i(d0_i),
      .d1_i(d1_i),
      .d2_i(d2_i),
      .done_i(done_i),

      .d0_o(d0_o),
      .d1_o(d1_o),
      .d2_o(d2_o),
      .d3_o(d3_o),
      .d4_o(d4_o),
      .d5_o(d5_o),
      .d6_o(d6_o),
      .d7_o(d7_o),
      .d8_o(d8_o),

      .done_o(done_o)

  );
  integer i;
  initial begin
    rst = 1'b1;
    d0_i = 8'b0;
    d1_i = 8'b0;
    d2_i = 8'b0;
    done_i = 1'b0;

    #(`clk_period);
    rst = 1'b0;
    done_i = 1'b1;


    for (i = 0; i < 30; i = i + 1) begin
      d0_i = i;
      d1_i = i + 1;
      d2_i = i + 2;
      #(`clk_period);
    end

    done_i = 1'b0;
    #(`clk_period);

    $stop;

  end

endmodule
