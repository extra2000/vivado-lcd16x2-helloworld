`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// LCD16x2 test bench
//////////////////////////////////////////////////////////////////////////////////////////////////


module helloworld_tb;

  reg        clk = 1'b0;
  wire       lcd_rs;
  wire       lcd_e;
  wire [7:0] lcd_data;

  helloworld UUT(
    .clk_i(clk),
    .lcd_rs_o(lcd_rs),
    .lcd_e_o(lcd_e),
    .lcd_databus_o(lcd_data)
  );

  // Delaying 125ns before inverting r_clock to simulate 8MHz clock.
  always #125 clk <= !clk;

endmodule
