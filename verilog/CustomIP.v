module CustomIP(input clk, input reset_n, input [1:0] address, input chipselect, input read, input write, input [31:0] writedata, output [9:0] led_out, output reg [31:0] readdata); endmodule
