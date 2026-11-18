`timescale 1ns / 1ps
module CustomIP_Classifier (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [6:0] sample_idx,
    output reg        done,
    output reg  [1:0] pred_class
);
    reg [7:0] feat_mem [0:12287];
    reg signed [7:0] w_mem [0:511];
    reg signed [15:0] b_mem [0:3];

    initial begin
        $readmemh("test_features.hex", feat_mem);
        $readmemh("fc_weights.hex", w_mem);
        $readmemh("fc_bias.hex", b_mem);
    end

    integer c, i;
    reg signed [31:0] score [0:3];
    reg signed [31:0] max_score;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 0;
            pred_class <= 0;
        end else if (start) begin
            for (c = 0; c < 4; c = c + 1) begin
                score[c] = b_mem[c];
                for (i = 0; i < 128; i = i + 1) begin
                    score[c] = score[c] + ($signed({1'b0, feat_mem[sample_idx*128 + i]}) * w_mem[c*128 + i]);
                end
            end
            max_score = score[0];
            pred_class <= 2'd0;
            if (score[1] > max_score) begin max_score = score[1]; pred_class <= 2'd1; end
            if (score[2] > max_score) begin max_score = score[2]; pred_class <= 2'd2; end
            if (score[3] > max_score) begin max_score = score[3]; pred_class <= 2'd3; end
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
