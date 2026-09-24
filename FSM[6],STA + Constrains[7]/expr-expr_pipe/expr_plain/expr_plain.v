`timescale 1ns / 1ps

module expr_plain(
input wire clk,
input wire rst,
input wire [7:0] a,
input wire [7:0] b,
input wire [7:0] c,
input wire [7:0] d,
output reg [15:0] out
    );
    reg [7:0] a_reg, b_reg, c_reg, d_reg; // входи реєстрові 
    
always @(posedge clk or posedge rst) begin // послідовна логіка 
    if (rst) begin
        a_reg <= 8'd0;
        b_reg <= 8'd0;
        c_reg <= 8'd0;
        d_reg <= 8'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        c_reg <= c;
        d_reg <= d;
     end
   end
   
always @(posedge clk or posedge rst) begin // довгий вираз без конвеєра + реєстр виходу
    if (rst)begin
        out <= 16'd0;
    end else begin
        out <= ((a_reg + b_reg )* c_reg ) - d_reg;
        end
    end    

endmodule
