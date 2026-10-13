`timescale 1ns / 1ps

module top_module #(
parameter FRAME_W = 320, // ширина 320 
parameter FRAME_H = 200, // висота кадра 200
parameter FIFO_DEPTH = 1024 // глибина буферу FIFO 
)(
input aclk,
input aresetn,
input start,             
input pix_clk,
input pix_valid,         
input [7:0]pix_data,
output [31:0]m_axis_tdata,
output m_axis_tvalid,
output m_axis_tlast,
output [3:0]m_axis_tkeep,
input m_axis_tready
);
    localparam FRAME_BYTES = FRAME_W * FRAME_H; // спільне число кадрів 
    localparam FRAME_WORDS = FRAME_BYTES / 4; // число 32-бітних слів в кадрі
    localparam CNT_W = $clog2(FRAME_BYTES);
(* ASYNC_REG = "TRUE" *) reg [1:0] start_sync = 2'b00;
reg start_sync_d;
always @(posedge pix_clk) begin
        start_sync   <= {start_sync[0], start};
        start_sync_d <= start_sync[1];
end
wire start_pix_pulse = start_sync[1] & ~start_sync_d;
reg capturing;
reg [CNT_W-1:0]wr_byte_cnt;
wire fifo_full;
wire fifo_wr_en = capturing & pix_valid & ~fifo_full;
wire [7:0]fifo_dout;
wire fifo_empty;
wire fifo_rd_en;

always @(posedge pix_clk) begin // двостановий автомат
    if (!start_sync[1]) begin
        capturing   <= 1'b0;
        wr_byte_cnt <= {CNT_W{1'b0}};
    end
    else if (start_pix_pulse) begin
        capturing   <= 1'b1;
        wr_byte_cnt <= {CNT_W{1'b0}};
    end
    else if (fifo_wr_en) begin
    if (wr_byte_cnt == FRAME_BYTES-1)
        capturing <= 1'b0;
        wr_byte_cnt <= wr_byte_cnt + 1'b1;
        end
    end
xpm_fifo_async #(
    .FIFO_MEMORY_TYPE ("block"),
    .FIFO_WRITE_DEPTH (FIFO_DEPTH),
    .WRITE_DATA_WIDTH (8),
    .READ_DATA_WIDTH  (8),
    .READ_MODE        ("fwft"),
    .CDC_SYNC_STAGES  (2)
) u_fifo (
    .wr_clk  (pix_clk),
    .rst     (~aresetn),
    .wr_en   (fifo_wr_en),
    .din     (pix_data),
    .full    (fifo_full),
    .rd_clk  (aclk),
    .rd_en   (fifo_rd_en),
    .dout    (fifo_dout),
    .empty   (fifo_empty)
);
reg [1:0]byte_cnt;
reg [31:0]pack_reg;
reg pack_valid;
reg [15:0]word_cnt;
// дозвіл читати із фіфо , коли 32-бітне слово ще не зібрано 
assign fifo_rd_en = ~pack_valid & ~fifo_empty;

always @(posedge aclk) begin
    if (!aresetn) begin
        byte_cnt   <= 2'd0;
        pack_reg   <= 32'd0;
        pack_valid <= 1'b0;
        word_cnt   <= 16'd0;
    end
    else begin
        if (pack_valid && m_axis_tready) begin
            pack_valid <= 1'b0;
        if (word_cnt == FRAME_WORDS-1)
            word_cnt <= 16'd0;
        else
            word_cnt <= word_cnt + 1'b1;
        end
        if (fifo_rd_en) begin
            pack_reg[byte_cnt*8 +: 8] <= fifo_dout;
        if (byte_cnt == 2'd3) begin
        byte_cnt   <= 2'd0;
        pack_valid <= 1'b1;
        end
        else
            byte_cnt <= byte_cnt + 1'b1;
        end
    end
end
assign m_axis_tdata  = pack_reg;
assign m_axis_tvalid = pack_valid;
assign m_axis_tkeep  = 4'b1111;
assign m_axis_tlast  = pack_valid && (word_cnt == FRAME_WORDS-1);
    
endmodule
