`timescale 1ns / 1ps
module tb_Accuracy;
    reg clk, rst_n, start;
    reg [6:0] sample_idx;
    wire done;
    wire [1:0] pred_class;
    reg [7:0] labels [0:95];
    integer idx, correct;
    real acc;

    CustomIP_Classifier uut (.clk(clk), .rst_n(rst_n), .start(start), .sample_idx(sample_idx), .done(done), .pred_class(pred_class));
    always #10 clk = ~clk;

    initial begin
        $readmemh("test_labels.hex", labels);
        clk = 0; rst_n = 0; start = 0; sample_idx = 0; correct = 0;
        #50 rst_n = 1; #20;
        for (idx = 0; idx < 96; idx = idx + 1) begin
            sample_idx = idx[6:0];
            start = 1; #20 start = 0; #20;
            if (pred_class == labels[idx][1:0]) correct = correct + 1;
        end
        acc = (correct * 100.0) / 96.0;
        $display("==========================================");
        $display("TOTAL SAMPEL UJI VERILOG : 96 Citra");
        $display("PREDIKSI BENAR HARDWARE  : %0d / 96", correct);
        $display("AKURASI VERILOG ^(FPGA^)   : %0.2f %%", acc);
        $display("==========================================");
        $stop;
    end
endmodule
