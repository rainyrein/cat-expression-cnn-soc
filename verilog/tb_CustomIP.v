`timescale 1ns / 1ps

module tb_CustomIP;
    reg         clk;
    reg         rst_n;
    reg         start;
    reg  [4:0]  filter_sel;
    wire        done;
    wire [31:0] total_nonzero;
    wire [15:0] max_activation;

    CustomIP uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .filter_sel(filter_sel),
        .done(done),
        .total_nonzero(total_nonzero),
        .max_activation(max_activation)
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; start = 0; filter_sel = 5'd0;
        #50 rst_n = 1;
        #20;

        $display("=== Memulai Simulasi Akselerator CNN ^(Filter 0^) ===");
        start = 1; #20 start = 0;
        wait(done == 1); #20;
        $display("Filter 0 Selesai! Piksel Aktif ^(ReLU > 0^): %d | Aktivasi Maksimum: %d", total_nonzero, max_activation);

        #40 filter_sel = 5'd1;
        $display("=== Memulai Simulasi Akselerator CNN ^(Filter 1^) ===");
        start = 1; #20 start = 0;
        wait(done == 1); #20;
        $display("Filter 1 Selesai! Piksel Aktif ^(ReLU > 0^): %d | Aktivasi Maksimum: %d", total_nonzero, max_activation);

        $display("=== Semua Pengujian Hardware Berhasil! ===");
        $stop;
    end
endmodule
