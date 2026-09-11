`timescale 1ns / 1ps

module tb_counter;
    reg clk; 
    reg rst;
    reg load;
    reg [3:0] data_in;
    reg en;
    reg up_down;
    wire [3:0] count;
    
    counter dut (
    .clk(clk), .rst(rst),
    .load(load), .data_in(data_in), 
    .en(en), .up_down(up_down),
    .count(count)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    //
    task automatic check_count;
        input [3:0] expected;
        input [8*40-1:0] name;
    begin
        if(count === expected)
            $display("pass : %0s | count = %0d", name, count );
        else
            $display ("fail : %0s | count %0d,got %0d", name , expected , count);
    end
    endtask
    // 
    initial begin 
        rst = 0;
        load = 0;
        en = 0;
        data_in = 0;
        up_down = 0;
        
        #1;
        rst=1;
    @(posedge clk); #1;
        rst = 0;
    
    load = 1; data_in = 4'd10;
    @(posedge clk); #1;
    load = 0;
    //
    check_count(4'd10, "load=10");
        en = 1;
        up_down = 1;    
    repeat (3) @(posedge clk); #1;
    check_count(4'd13, " up to 13");
    //
    repeat (3) @(posedge clk); #1;
    check_count (4'd0, "up wrap 15 - 0");
    //
        en = 0 ;
    repeat (2) @(posedge clk); #1;
    check_count (4'd0,"(en=0)");
    
        en=1; up_down=0;
    @(posedge clk); #1;
    check_count (4'd15, "down wrap 0-15");
    
    // load над en , навмисно обидва активні
        load =1; data_in= 4'd5; en=1; up_down=1;
    @(posedge clk); #1;
        load=0;
    check_count (4'd5, "load priority en");
            $display ("[%0t ns] Simulation finished" , $time);
            $finish;         
    end
endmodule
