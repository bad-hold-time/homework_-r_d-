`timescale 1ns / 1ps
 
module tb_top_module;
 
    localparam FRAME_BYTES = 320 * 200;
reg clk = 0;
reg rst = 1;
reg [0:0] btn = 0;
reg pix_valid = 0;
reg [7:0] pix_data = 0;
integer i;
 
always #5 clk = ~clk;
 
design_1_wrapper dut (
    .clk_100MHz  (clk),
    .reset_rtl_0 (rst),
    .gpio_io_i_0 (btn),
    .pix_data_0  (pix_data),
    .pix_valid_0 (pix_valid)
);
 
initial begin
    #200 rst = 0;
    #50000 btn = 1;
    wait (dut.design_1_i.top_module_0.start === 1'b1);
    repeat (10) @(negedge clk);
    for (i = 0; i < FRAME_BYTES; i = i + 1) begin
        @(negedge clk);
            pix_valid = 1;
            pix_data  = i[7:0];
        @(negedge clk);
            pix_valid = 0;
    end
repeat (5000) @(posedge clk);
    $finish;
end
 
endmodule