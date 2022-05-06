`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// LCD16x2 module
//////////////////////////////////////////////////////////////////////////////////////////////////


module lcd16x2 #(
  parameter integer CLK_FREQ      = 8000000,   // 8MHz
  // Timing cycles
  parameter [19:0]  T_40_NS       = $ceil(0.000000040 * CLK_FREQ),
  parameter [19:0]  T_250_NS      = $ceil(0.000000250 * CLK_FREQ),
  parameter [19:0]  T_42_US       = $ceil(0.000042000 * CLK_FREQ),
  parameter [19:0]  T_60_US       = $ceil(0.000060000 * CLK_FREQ),
  parameter [19:0]  T_100_US      = $ceil(0.000100000 * CLK_FREQ),
  parameter [19:0]  T_5000_US     = $ceil(0.005000000 * CLK_FREQ),
  parameter [19:0]  T_100_MS      = $ceil(0.100000000 * CLK_FREQ),
  // Commands
  parameter [7:0]   CMD_SETUP     = 8'b00111000,  // Set 8-bit, 2-line, 5x7 dots
  parameter [7:0]   CMD_DISP_ON   = 8'b00001100,  // Turn ON display
  parameter [7:0]   CMD_ALL_ON    = 8'b00001111,  // Turn ON all display
  parameter [7:0]   CMD_DISP_OFF  = 8'b00001000,  // Turn OFF display
  parameter [7:0]   CMD_CLEAR     = 8'b00000001,  // Clear display
  parameter [7:0]   CMD_ENTRY_N   = 8'b00000110   // Normal entry
) (
  input            clk_i,
  input      [7:0] data_i,     // 8-bit data input
  input      [1:0] ops_i,      // operation mode
  input            enb_i,      // tells this module that the data is valid
  input            rst_i,
  output reg       rdy_o,      // indicate whether this module is idle
  output reg       lcd_rs_o,
  output reg       lcd_e_o,
  output reg [7:0] lcd_databus_o  // data bus
);

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // Counting mechanism
  ////////////////////////////////////////////////////////////////////////////////////////////////
  reg [19:0] cnt_timer     = 0;
  reg        flag_40_ns    = 0;
  reg        flag_250_ns   = 0;
  reg        flag_42_us    = 0;
  reg        flag_60_us    = 0;
  reg        flag_100_us   = 0;
  reg        flag_5000_us  = 0;
  reg        flag_100_ms   = 0;
  reg        flag_rst      = 1;  // start with RST flag set, so the counting can't be started

  always @(posedge clk_i) begin
    if (flag_rst) begin
      flag_40_ns    <= 0;
      flag_250_ns   <= 0;
      flag_42_us    <= 0;
      flag_60_us    <= 0;
      flag_100_us   <= 0;
      flag_5000_us  <= 0;
      flag_100_ms   <= 0;
      cnt_timer     <= 0;
    end else begin
      if (cnt_timer >= T_40_NS) begin
        flag_40_ns <= 1;
      end
      if (cnt_timer >= T_250_NS) begin
        flag_250_ns <= 1;
      end
      if (cnt_timer >= T_42_US) begin
        flag_42_us <= 1;
      end
      if (cnt_timer >= T_60_US) begin
        flag_60_us <= 1;
      end
      if (cnt_timer >= T_100_US) begin
        flag_100_us <= 1;
      end
      if (cnt_timer >= T_5000_US) begin
        flag_5000_us <= 1;
      end
      if (cnt_timer >= T_100_MS) begin
        flag_100_ms <= 1;
      end
      cnt_timer <= cnt_timer + 1;
    end
  end

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // State machine
  ////////////////////////////////////////////////////////////////////////////////////////////////
  reg [3:0] state    = 0;
  reg [3:0] substate = 0;

  always @(posedge clk_i) begin
    case (state)
      ////////////////////
      // Wait for 100ms //
      ////////////////////
      0: begin
        rdy_o <= 0;
        if (substate == 0) begin
          if (!flag_100_ms) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_e_o <= 0;
          if (!flag_60_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      //////////////////////////////////////////////////
      // Entering function set 1st try and wait 4.1ms //
      //////////////////////////////////////////////////
      1: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_rs_o <= 0;
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= 8'b00110000;  // triggering function set
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 6) begin
          if (!flag_5000_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 7) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      //////////////////////////////////////////////////
      // Entering function set 2nd try and wait 100us //
      //////////////////////////////////////////////////
      2: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_e_o <= 0;
          if (!flag_100_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      ///////////////////////////////////
      // Entering function set 3rd try //
      ///////////////////////////////////
      3: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_e_o <= 0;
          if (!flag_100_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      /////////////////////
      // Do function set //
      /////////////////////
      4: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= CMD_SETUP;
          if(!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_100_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      /////////////////
      // Display off //
      /////////////////
      5: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= CMD_DISP_OFF;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_60_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      //////////////////////////
      // Clear display screen //
      //////////////////////////
      6: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= CMD_CLEAR;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_5000_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      ///////////////////////////////////////////////////////////
      // Set Entry Mode to: cursor moves, display stands still //
      ///////////////////////////////////////////////////////////
      7: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= CMD_ENTRY_N;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_60_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= state + 1;
            substate <= 0;
          end
        end
      end
      ////////////////
      // Display on //
      ////////////////
      8: begin
        rdy_o <= 0;
        if (substate == 0) begin
          lcd_e_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= CMD_DISP_ON;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_60_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= -1;
            substate <= 0;
          end
        end
      end
      ////////////////
      // Write data //
      ////////////////
      9: begin
        if (substate == 0) begin
          rdy_o <= 0;
          lcd_e_o <= 1;
          lcd_rs_o <= 1;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= data_i;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 6) begin
          rdy_o <= 1;
          if (!flag_42_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 7) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= -1;
            substate <= 0;
          end
        end
      end
      ////////////////////////
      // Write instructions //
      ////////////////////////
      10: begin
        if (substate == 0) begin
          rdy_o <= 0;
          lcd_e_o <= 1;
          lcd_rs_o <= 0;
          if (!flag_40_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 1) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 2) begin
          lcd_databus_o <= data_i;
          if (!flag_250_ns) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 3) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 4) begin
          lcd_e_o <= 0;
          if (!flag_42_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 5) begin
          if (flag_rst && cnt_timer == 0) begin
            substate <= substate + 1;
          end
        end
        if (substate == 6) begin
          rdy_o <= 1;
          if (!flag_42_us) begin
            flag_rst <= 0;
          end else begin
            flag_rst <= 1;
            substate <= substate + 1;
          end
        end
        if (substate == 7) begin
          if (flag_rst && cnt_timer == 0) begin
            state <= -1;
            substate <= 0;
          end
        end
      end
      ///////////////////////////////////////////////////////
      // The idle state. Do nothing until operation is set //
      ///////////////////////////////////////////////////////
      default: begin
        rdy_o <= 1;
        if ((enb_i == 1) && (rst_i == 0)) begin
          case (ops_i)
            0: state <= state;  // idle
            1: state <= 9;      // write character
            2: state <= 0;      // reset
            3: state <= 10;     // write instruction
          endcase
        end
        if (rst_i == 1) begin
          state <= 0;
        end
      end
    endcase
  end

endmodule
