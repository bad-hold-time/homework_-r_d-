`timescale 1ns / 1ps

module tb_expr;
    reg clk;
    reg rst;
    reg [7:0] a,b,c,d;
    wire [15:0] result_plain;
    wire [15:0] result_pipe;
    
expr_pipelined dut_pipe ( .clk(clk), .rst(rst), .a(a), .b(b), .c(c), .d(d), .out(result_pipe));
    
    initial clk = 0;
    always #5 clk = ~clk;
    
task automatic  check_case;
    input [15:0] a_val,b_val,c_val,d_val;
    input [31:0] expected;
    input [8*24-1:0] name;
        begin
            a = a_val; b = b_val; c = c_val; d = d_val;
                
    @(posedge clk); #1;
        if(result_plain !== expected)
            $display("[%0t ns] FAIL (plain); %0s -> expected %0d, got %0d", $time, 
                            name, expected, result_plain);
            else
            $display("[%0t ns] PASS (plain): %0s -> result=%0d", $time, name, result_plain);
                    
    @(posedge clk); #1;
        if(result_pipe !== expected)
            $display("[%0t ns] FAIL (pipelined): %0s -> expected %0d, got %0d",
                            $time, name, expected, result_pipe);
            else
            $display("[%0t ns] PASS (pipelined): %0s -> result=%0d", $time, name, result_pipe);
        end
    endtask
    
initial begin
        rst = 1; a = 0; b = 0; c = 0; d = 0;
    @(posedge clk); #1;
        rst = 0;
        // (5+3)*4-10 = 32-10 = 22
        check_case(16'd5, 16'd3, 16'd4, 16'd10, 32'd22, "case1: (5+3)*4-10=22");
        // (10+20)*2-5 = 60-5 = 55
        check_case(16'd10, 16'd20, 16'd2, 16'd5, 32'd55, "case2: (10+20)*2-5=55");
            $display("[%0t ns] Simulation finished", $time);
        $finish;
    end
                  
endmodule
