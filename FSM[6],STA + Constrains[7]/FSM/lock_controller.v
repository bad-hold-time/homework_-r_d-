`timescale 1ns / 1ps


module lock_controller(
input clk,
input rst, 
input [3:0] digit_in,
output reg unlocked_led
    );
     wire [3:0] digit_clean;
        debounce #(.COUNT_MAX(200_000)) db0 (.clk(clk), .btn_raw(digit_in[0]), .btn_clean(digit_clean[0]));
        debounce #(.COUNT_MAX(200_000)) db1 (.clk(clk), .btn_raw(digit_in[1]), .btn_clean(digit_clean[1]));
        debounce #(.COUNT_MAX(200_000)) db2 (.clk(clk), .btn_raw(digit_in[2]), .btn_clean(digit_clean[2]));
        debounce #(.COUNT_MAX(200_000)) db3 (.clk(clk), .btn_raw(digit_in[3]), .btn_clean(digit_clean[3]));

           ///
localparam LOCKED = 2'd0,
           WAIT_D2 = 2'd1,
           WAIT_D3 = 2'd2,
           UNLOCKED = 2'd3;
           ///
localparam  [11:0] CODE = {4'd5,4'd3,4'd7};
reg [1:0] state,next_state;

 // реєстр стану  
    always @(posedge clk or posedge rst) begin
        if(rst)
            state <= LOCKED;
        else 
            state <= next_state;
    end
    // comb №2
    always @(*) begin
        next_state = state;
            case(state)
                LOCKED  : next_state = (digit_in==CODE[11:8])? WAIT_D2 : LOCKED;
                WAIT_D2 : next_state = (digit_in==CODE[7:4])? WAIT_D3 : LOCKED;
                WAIT_D3 : next_state = (digit_in==CODE[3:0])? UNLOCKED : LOCKED;
                UNLOCKED: next_state = UNLOCKED;
            endcase
    end
    // comb №3 logic output
    always @(*)begin
        unlocked_led = (state == UNLOCKED);
    end
endmodule

// debounce module
module debounce #(
parameter integer COUNT_MAX=200_000)(
input clk,
input btn_raw,
output reg  btn_clean
);

    reg [17:0] counter;
    always@(posedge clk) begin
    if (btn_raw != btn_clean) begin
        counter <= counter +1'b1;
        if(counter == COUNT_MAX) begin
            btn_clean <= btn_raw;
            counter <= 0;
        end
        end else begin
            counter <= 0;
        end
    end
endmodule 
