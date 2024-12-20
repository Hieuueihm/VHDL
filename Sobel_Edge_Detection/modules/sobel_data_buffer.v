module sobel_data_buffer #(
    parameter DEPTH,
    parameter ROWS,
    parameter COLS
) (
    input clk,
    input rst,
    input [7:0] data_i,
    input we_i,

    output [7:0] d0_o,
    output [7:0] d1_o,
    output [7:0] d2_o,
    output [7:0] d3_o,
    output [7:0] d4_o,
    output [7:0] d5_o,
    output [7:0] d6_o,
    output [7:0] d7_o,
    output [7:0] d8_o,
    output done_o
);

  wire [7:0] data0_o, data1_o, data2_o;
  wire double_done_o;


  fifo_double_line_buffer #(
      .DEPTH(DEPTH),
  ) DOUBLE_LINE_BUFFER (
      .clk(clk),
      .rst(rst),
      .we_i(we_i),
      .data_i(data_i),
      .data0_o(data0_o),
      .data1_o(data1_o),
      .data2_o(data2_o),

      .done_o(double_done_o)
  );


  sobel_data_modulate #(
      .ROWS(ROWS),
      .COLS(COLS)
  ) SOBEL_DATA_MODULATE (
      .clk(clk),
      .rst(rst),
      .d0_i(data0_o),
      .d1_i(data1_o),
      .d2_i(data2_o),
      .done_i(double_done_o),

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


endmodule
