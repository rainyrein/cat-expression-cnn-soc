`timescale 1ns / 1ps

module CustomIP #(
    parameter IMG_WIDTH  = 64,
    parameter IMG_HEIGHT = 64,
    parameter NUM_FILTER = 32
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [4:0]  filter_sel,
    output reg         done,
    output reg  [31:0] total_nonzero,
    output reg  [15:0] max_activation
);

    reg [7:0] img_mem [0:(IMG_WIDTH*IMG_HEIGHT)-1];
    reg signed [7:0] weight_mem [0:(NUM_FILTER*9)-1];
    reg [15:0] feature_map [0:((IMG_WIDTH-2)*(IMG_HEIGHT-2))-1];

    initial begin
        $readmemh("cat_sample_image.hex", img_mem);
        $readmemh("cnn_weights.hex", weight_mem);
    end

    reg [5:0] row, col;
    reg [1:0] state;
    localparam IDLE = 2'd0, COMPUTE = 2'd1, FINISH = 2'd2;

    integer w_offset;
    reg signed [23:0] mac_sum;
    reg [15:0] relu_out;
    integer idx_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            done           <= 1'b0;
            row            <= 6'd0;
            col            <= 6'd0;
            total_nonzero  <= 32'd0;
            max_activation <= 16'd0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        row            <= 6'd0;
                        col            <= 6'd0;
                        total_nonzero  <= 32'd0;
                        max_activation <= 16'd0;
                        state          <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    w_offset = filter_sel * 9;
                    mac_sum =
                        ($signed({1'b0, img_mem[(row+0)*IMG_WIDTH + (col+0)]}) * weight_mem[w_offset + 0]) +
                        ($signed({1'b0, img_mem[(row+0)*IMG_WIDTH + (col+1)]}) * weight_mem[w_offset + 1]) +
                        ($signed({1'b0, img_mem[(row+0)*IMG_WIDTH + (col+2)]}) * weight_mem[w_offset + 2]) +
                        ($signed({1'b0, img_mem[(row+1)*IMG_WIDTH + (col+0)]}) * weight_mem[w_offset + 3]) +
                        ($signed({1'b0, img_mem[(row+1)*IMG_WIDTH + (col+1)]}) * weight_mem[w_offset + 4]) +
                        ($signed({1'b0, img_mem[(row+1)*IMG_WIDTH + (col+2)]}) * weight_mem[w_offset + 5]) +
                        ($signed({1'b0, img_mem[(row+2)*IMG_WIDTH + (col+0)]}) * weight_mem[w_offset + 6]) +
                        ($signed({1'b0, img_mem[(row+2)*IMG_WIDTH + (col+1)]}) * weight_mem[w_offset + 7]) +
                        ($signed({1'b0, img_mem[(row+2)*IMG_WIDTH + (col+2)]}) * weight_mem[w_offset + 8]);

                    if (mac_sum > 0)
                        relu_out = mac_sum[18:3];
                    else
                        relu_out = 16'd0;

                    idx_out = row * (IMG_WIDTH - 2) + col;
                    feature_map[idx_out] <= relu_out;

                    if (relu_out > 0)
                        total_nonzero <= total_nonzero + 1'b1;
                    if (relu_out > max_activation)
                        max_activation <= relu_out;

                    if (col == IMG_WIDTH - 3) begin
                        col <= 6'd0;
                        if (row == IMG_HEIGHT - 3) begin
                            state <= FINISH;
                        end else begin
                            row <= row + 1'b1;
                        end
                    end else begin
                        col <= col + 1'b1;
                    end
                end

                FINISH: begin
                    done  <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
