`timescale 1ns / 1ps

module tb_Colab;
    reg clk;
    reg rst_n;

    reg start_conv;
    reg [4:0] filter_sel;
    wire done_conv;
    wire [31:0] total_active;
    wire signed [15:0] max_activation;

    CustomIP uut_conv (
        clk,
        rst_n,
        start_conv,
        filter_sel,
        done_conv,
        total_active,
        max_activation
    );

    reg start_cls;
    reg [6:0] sample_idx;
    wire done_cls;
    wire [1:0] pred_class;

    reg [7:0] test_labels [0:95];
    integer idx;
    integer correct;
    real accuracy;

    CustomIP_Classifier uut_cls (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_cls),
        .sample_idx(sample_idx),
        .done(done_cls),
        .pred_class(pred_class)
    );

    always #10 clk = ~clk;

    initial begin
        $readmemh("test_labels.hex", test_labels);

        clk = 0; rst_n = 0;
        start_conv = 0; filter_sel = 5'd0;
        start_cls = 0; sample_idx = 7'd0;
        correct = 0;

        #50 rst_n = 1;
        #20;

        $display("==========================================================");
        $display(" TAHAP 1: SIMULASI KONVOLUSI 2D + ReLU (CustomIP.v)");
        $display("==========================================================");

        filter_sel = 5'd0;
        start_conv = 1; #20 start_conv = 0;
        wait(done_conv == 1); #20;
        $display("Filter 0 -> Piksel Aktif (ReLU > 0): %0d | Aktivasi Maks: %0d", total_active, max_activation);

        filter_sel = 5'd1;
        start_conv = 1; #20 start_conv = 0;
        wait(done_conv == 1); #20;
        $display("Filter 1 -> Piksel Aktif (ReLU > 0): %0d | Aktivasi Maks: %0d", total_active, max_activation);

        $display("");
        $display("==========================================================");
        $display(" TAHAP 2: PENGUJIAN AKURASI VERILOG (96 CITRA UJI)");
        $display("==========================================================");

        for (idx = 0; idx < 96; idx = idx + 1) begin
            sample_idx = idx[6:0];
            start_cls = 1; #20 start_cls = 0; #20;
            if (pred_class == test_labels[idx][1:0])
                correct = correct + 1;
        end

        accuracy = (correct * 100.0) / 96.0;
        $display("Total Sampel Uji        : 96 Citra");
        $display("Prediksi Benar Hardware : %0d / 96", correct);
        $display("AKURASI VERILOG (FPGA)  : %0.2f %%", accuracy);
        $display("AKURASI PYTHON (FP32)   : 86.46 %%");
        $display("==========================================================");

        $finish;
    end
endmodule
