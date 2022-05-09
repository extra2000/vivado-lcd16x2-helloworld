`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////
//234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
//        1         2         3         4         5         6         7         8         9
//------------------------------------------------------------------------------------------------
// Hello World module that prints "HITACHI\nヒタチ"
//////////////////////////////////////////////////////////////////////////////////////////////////


module helloworld #(
  parameter [4:0] NUM_OF_CHARS = 16,
  parameter [7:0] LCD_SETDDRAMADDR = 8'b10000000,
  parameter [7:0] LCD_ROW_OFFSET = 8'b01000000
) (
  input clk_i,
  output lcd_rs_o,
  output lcd_e_o,
  output [7:0] lcd_databus_o
);

  reg [7:0] data = 8'b00000000;
  reg [1:0] ops = 2'b00;
  reg enb = 1'b0;
  reg rst = 1'b0;
  wire rdy;

  lcd16x2 lcd16x2_inst(
    .clk_i(clk_i),
    .data_i(data),
    .ops_i(ops),
    .enb_i(enb),
    .rst_i(rst),
    .rdy_o(rdy),
    .lcd_rs_o(lcd_rs_o),
    .lcd_e_o(lcd_e_o),
    .lcd_databus_o(lcd_databus_o)
  );

  reg [7:0] line_1_chars [0:NUM_OF_CHARS];
  reg [7:0] line_2_chars [0:NUM_OF_CHARS];
  initial begin
    line_1_chars[ 0] = 8'b01001000;  // "H"
    line_1_chars[ 1] = 8'b01001001;  // "I"
    line_1_chars[ 2] = 8'b01010100;  // "T"
    line_1_chars[ 3] = 8'b01000001;  // "A"
    line_1_chars[ 4] = 8'b01000011;  // "C"
    line_1_chars[ 5] = 8'b01001000;  // "H"
    line_1_chars[ 6] = 8'b01001001;  // "I"
    line_1_chars[ 7] = 8'b00100000;  // " "
    line_1_chars[ 8] = 8'b00100000;  // " "
    line_1_chars[ 9] = 8'b00100000;  // " "
    line_1_chars[10] = 8'b00100000;  // " "
    line_1_chars[11] = 8'b00100000;  // " "
    line_1_chars[12] = 8'b00100000;  // " "
    line_1_chars[13] = 8'b00100000;  // " "
    line_1_chars[14] = 8'b00100000;  // " "
    line_1_chars[15] = 8'b00100000;  // " "

    line_2_chars[ 0] = 8'b11001011;  // "ヒ"
    line_2_chars[ 1] = 8'b11000000;  // "タ"
    line_2_chars[ 2] = 8'b11000001;  // "チ"
    line_2_chars[ 3] = 8'b00100000;  // " "
    line_2_chars[ 4] = 8'b00100000;  // " "
    line_2_chars[ 5] = 8'b00100000;  // " "
    line_2_chars[ 6] = 8'b00100000;  // " "
    line_2_chars[ 7] = 8'b00100000;  // " "
    line_2_chars[ 8] = 8'b00100000;  // " "
    line_2_chars[ 9] = 8'b00100000;  // " "
    line_2_chars[10] = 8'b00100000;  // " "
    line_2_chars[11] = 8'b00100000;  // " "
    line_2_chars[12] = 8'b00100000;  // " "
    line_2_chars[13] = 8'b00100000;  // " "
    line_2_chars[14] = 8'b00100000;  // " "
    line_2_chars[15] = 8'b00100000;  // " "
  end

  ////////////////////////////////////////////////////////////////////////////////////////////////
  // State machine for printing "HITACHI\nヒタチ"
  ////////////////////////////////////////////////////////////////////////////////////////////////
  reg [3:0] state = 0;
  reg [4:0] substate = 0;
  reg [1:0] subsubstate = 0;

  always @(posedge clk_i) begin
    case (state)
      0: begin
          if (substate < NUM_OF_CHARS) begin
            if (subsubstate == 0) begin
              if (rdy) begin
                data <= line_1_chars[substate];
                ops <= 1;
                enb <= 1;
                subsubstate <= subsubstate + 1;
              end
            end
            if (subsubstate == 1) begin
              if (!rdy) begin
                subsubstate <= subsubstate + 1;
                enb <= 0;
              end
            end
            if (subsubstate == 2) begin
              if (rdy) begin
                substate <= substate + 1;
                subsubstate <= 0;
              end
            end
          end else begin
            if (rdy) begin
              state <= state + 1;
              substate <= 0;
              subsubstate <= 0;
            end
          end
      end
      1: begin  // newline
        if (substate == 0) begin
          if (rdy) begin
            data <= LCD_SETDDRAMADDR | LCD_ROW_OFFSET;
            ops <= 3;
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
      end
      2: begin
          if (substate < NUM_OF_CHARS) begin
            if (subsubstate == 0) begin
              if (rdy) begin
                data <= line_2_chars[substate];
                ops <= 1;
                enb <= 1;
                subsubstate <= subsubstate + 1;
              end
            end
            if (subsubstate == 1) begin
              if (!rdy) begin
                subsubstate <= subsubstate + 1;
                enb <= 0;
              end
            end
            if (subsubstate == 2) begin
              if (rdy) begin
                substate <= substate + 1;
                subsubstate <= 0;
              end
            end
          end else begin
            if (rdy) begin
              state <= state + 1;
              substate <= 0;
              subsubstate <= 0;
            end
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
