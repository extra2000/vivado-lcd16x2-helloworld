`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// LCD16x2 test bench
//////////////////////////////////////////////////////////////////////////////////////////////////


module helloworld_tb #(
  // delay 4ns (8ns for a complete oscillation) to simulate Arty Z7-20 125MHz system clock
  parameter reg [2:0] T_DELAY_4_NS = 4
) ();

  reg        sysclock = 1'b0;
  wire       lcd_rs;
  wire       lcd_e;
  wire [7:0] lcd_data;

  helloworld UUT(
    .clk_i(sysclock),
    .lcd_rs_o(lcd_rs),
    .lcd_e_o(lcd_e),
    .lcd_databus_o(lcd_data)
  );

  // Delaying 4ns before inverting r_clock to simulate 8MHz clock.
  always #T_DELAY_4_NS sysclock <= ~sysclock;

endmodule
