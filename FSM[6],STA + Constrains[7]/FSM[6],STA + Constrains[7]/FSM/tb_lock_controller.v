`timescale 1ns / 1ps

module tb_lock_controller;
reg clk;
reg rst;
reg [3:0] digit_in;
wire  unlocked_led;

lock_controller dut (
.clk(clk), 
.rst(rst), 
.digit_in(digit_in), 
.unlocked_led(unlocked_led)
);
    defparam dut.db0.COUNT_MAX = 5;
    defparam dut.db1.COUNT_MAX = 5;
    defparam dut.db2.COUNT_MAX = 5;
    defparam dut.db3.COUNT_MAX = 5;

    initial clk = 0;
    always #5 clk = ~clk;
    // generation clk
    
 task automatic check_lock_controller;
    input   expected;
    input [8*40-1:0] name;
    begin
        if (unlocked_led === expected) 
            $display ("[%0t ns] PASS: %0s -> unlocked_led=%b", $time, name, unlocked_led);
        else
            $display ("[%0t ns] FAIL : %0s ->  expected %b, got %b", $time, name, expected, unlocked_led);    
        end
 endtask
 
 initial begin
    rst = 1;
    digit_in = 4'd0;
 @(posedge clk); #1;
    rst=0;
    digit_in = 4'd5;
 @(posedge clk); #1;
    check_lock_controller(0, "after digit_in = 5, still locked");
    rst = 0;
    digit_in = 4'd3;
 @(posedge clk); #1;
    check_lock_controller (0, "after digit_in = 3, still locked");
    rst = 0;
    digit_in = 4'd7;
 @(posedge clk); #1;
    check_lock_controller (1, "after digit_in = 7, unlocked" );
    rst = 1;
 @(posedge clk); #1;
    rst = 0;  
    digit_in = 4'd3;
 @(posedge clk); #1;
    check_lock_controller (0, "wrong digit, expect locked");
 @(posedge clk); #1;
    digit_in = 4'd5;
 @(posedge clk); #1;
    check_lock_controller (0, "after digit_in = 5, still locked");
 @(posedge clk); #1;
    digit_in = 4'd5;
 @(posedge clk); #1;
    check_lock_controller (0, "wrong digit, expect locked");
    rst = 1;
    $finish;
 end
endmodule
