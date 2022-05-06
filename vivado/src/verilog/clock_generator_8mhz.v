`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// 8MHz Clock Generator module
//////////////////////////////////////////////////////////////////////////////////////////////////


module clock_generator_8mhz #(
  parameter integer CLK_FREQ = 125000000,  // 125MHz
  parameter integer T_125_NS  = $ceil(0.000000125 * CLK_FREQ)
) (
  input      clk_i,
  output reg clk_o
);

integer cnt_timer = 0;
reg     flag_rst  = 1;

always @(posedge clk_i) begin
  if (flag_rst) begin
    clk_o <= 0;
    cnt_timer  <= 0;
    flag_rst <= 0;
  end else begin
    if (cnt_timer >= T_125_NS) begin
      clk_o <= ~clk_o;
      cnt_timer <= 0;
    end else begin
      cnt_timer <= cnt_timer + 1;
    end
  end
end

endmodule
