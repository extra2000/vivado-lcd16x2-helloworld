`timescale 1ns / 1ps


module helloworld #(
  parameter [3:0] NUM_OF_CHARS = 11
) (
  input        clk_i,
  output       lcd_rs_o,
  output       lcd_e_o,
  output [7:0] lcd_data_o
);

  reg  [7:0] data = 8'b00000000;
  reg  [1:0] ops  = 2'b00;
  reg        enb  = 1'b0;
  reg        rst  = 1'b0;
  wire       rdy;

  lcd16x2 lcd16x2_i(
    .clk_i(clk_i),
    .data_i(data),
    .ops_i(ops),
    .enb_i(enb),
    .rst_i(rst),
    .rdy_o(rdy),
    .lcd_rs_o(lcd_rs_o),
    .lcd_e_o(lcd_e_o),
    .lcd_data_o(lcd_data_o)
  );

  reg [7:0] chars [0:NUM_OF_CHARS];
  initial begin
    chars[0]  = 8'b01001000;  // "H"
    chars[1]  = 8'b01000101;  // "E"
    chars[2]  = 8'b01001100;  // "L"
    chars[3]  = 8'b01001100;  // "L"
    chars[4]  = 8'b01001111;  // "O"
    chars[5]  = 8'b00100000;  // " "
    chars[6]  = 8'b01010111;  // "W"
    chars[7]  = 8'b01001111;  // "O"
    chars[8]  = 8'b01010010;  // "R"
    chars[9]  = 8'b01001100;  // "L"
    chars[10] = 8'b01000100;  // "D"
  end

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // State machine for printing "HELLO WORLD"
  ////////////////////////////////////////////////////////////////////////////////////////////////
  reg [3:0] state = 0;
  reg [1:0] substate = 0;

  always @(posedge clk_i) begin
    if (state < NUM_OF_CHARS) begin
      if (substate == 0) begin
        if (rdy) begin
          data <= chars[state];
          ops <= 1;
          enb <= 1;
          substate <= substate + 1;
        end
      end
      if (substate == 1) begin
        if (!rdy) begin
          substate <= substate + 1;
          enb <= 0;
        end
      end
      if (substate == 2) begin
        if (rdy) begin
          state <= state + 1;
          substate <= 0;
        end
      end
    end else begin
      if (rdy) begin
        enb <= 1'b0;
      end
    end
  end

endmodule
