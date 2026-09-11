`timescale 1ns / 1ps

module counter(
    input wire clk, 
    input wire rst, 
    input wire load,
    input wire [3:0] data_in, 
    input wire en, 
    input wire up_down,
    output reg [3:0] count
    );
    always @(posedge clk or posedge rst) begin
    if(rst) begin
    count <= 4'd0;
    end
    else if (load) begin 
    count <= data_in;
    end
    else if (en) begin
    if (up_down)
    count <= count + 1;
    else 
    count <= count -1;
    end
    else 
    count <= count;
    end
endmodule
