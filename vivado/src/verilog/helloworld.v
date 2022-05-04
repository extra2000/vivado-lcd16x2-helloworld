`timescale 1ns / 1ps


module helloworld(
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

  reg [7:0] chars [0:11];
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
    case (state)
      0: begin  // write "H"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[0];
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
      end
      1: begin  // write "E"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[1];
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
      end
      2: begin  // write "L"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[2];
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
      end
      3: begin  // write "L"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[3];
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
      end
      4: begin  // write "O"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[4];
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
      end
      5: begin  // write " "
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[5];
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
      end
      6: begin  // write "W"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[6];
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
      end
      7: begin  // write "O"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[7];
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
      end
      8: begin  // write "R"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[8];
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
      end
      9: begin  // write "L"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[9];
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
      end
      10: begin  // write "D"
        if (substate == 0) begin
          if (rdy) begin
            data <= chars[10];
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
      end
      default: begin
        if (rdy) begin
          enb <= 1'b0;
        end
      end
    endcase
  end

endmodule
