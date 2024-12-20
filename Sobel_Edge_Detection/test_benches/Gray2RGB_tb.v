`timescale 1ns / 1ps



`define clk_period 10


module Gray2RGB_tb ();

  reg clk, rst, done_i;
  reg [7:0] grayscale_i;
  wire done_o;
  wire [7:0] red_o, green_o, blue_o;


  initial clk = 1'b1;
  always #(`clk_period / 2) clk = ~clk;
  Gray2RGB uut (
      .clk(clk),
      .rst(rst),
      .done_i(done_i),
      .grayscale_i(grayscale_i),
      .red_o(red_o),
      .green_o(green_o),
      .blue_o(blue_o),
      .done_o(done_o)
  );
  integer i;
  initial begin
    rst    = 1'b1;
    done_i = 1'b0;

    #(`clk_period);

    rst = 1'b0;
    done_i = 1'b1;

    for (i = 0; i < 9; i=i+1) begin
      grayscale_i = i + 1;
      #(`clk_period);
    end

    #(`clk_period);
    done_i = 1'b0;

    #(`clk_period);

    $stop;

  end

endmodule
