`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// LCD16x2 test bench
//////////////////////////////////////////////////////////////////////////////////////////////////


module lcd16x2_tb;

  reg clk = 1'b0;

  reg  [7:0] data = 8'b00000000;
  reg  [1:0] ops = 2'b00;
  reg        enb = 1'b0;
  reg        rst = 1'b0;
  wire       rdy;
  wire       lcd_rs;
  wire       lcd_e;
  wire [7:0] lcd_data;

  lcd16x2 UUT(
    .clk_i(clk),
    .data_i(data),
    .ops_i(ops),
    .enb_i(enb),
    .rst_i(rst),
    .rdy_o(rdy),
    .lcd_rs_o(lcd_rs),
    .lcd_e_o(lcd_e),
    .lcd_data_o(lcd_data)
  );

  // Delaying 8ns before inverting r_clock to simulate 125MHz clock.
  always #8 clk <= !clk;

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // State machine
  ////////////////////////////////////////////////////////////////////////////////////////////////
  reg [1:0] state = 1'b0;

  always @(posedge clk) begin
    case (state)
      0: begin
        if (rdy) begin
          // write "H" character
          data <= 8'b01001000;
          ops <= 1;
          enb <= 1'b1;
          state <= state + 1;
        end
      end
      default: begin
        if (rdy) begin
          enb <= 1'b0;
        end
      end
    endcase
  end

endmodule
