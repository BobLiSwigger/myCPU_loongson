`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/16 23:41:09
// Design Name: 
// Module Name: dcache
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dcache(
    input         clk,
    input         resetn,
    input  [29:0] raddr,
    input         clear,
    input         wen,
    input  [29:0] waddr,
    input  [31:0] wdata,
    output [31:0] rdata,
    output        data_in_cache
    );
    /*-------------------------------cache memoory-------------------------------*/
    reg [56:0] cache_data [63:0];
    initial begin
        cache_data[0] <= 57'b0;
        cache_data[1] <= 57'b0;
        cache_data[2] <= 57'b0;
        cache_data[3] <= 57'b0;
        cache_data[4] <= 57'b0;
        cache_data[5] <= 57'b0;
        cache_data[6] <= 57'b0;
        cache_data[7] <= 57'b0;
        cache_data[8] <= 57'b0;
        cache_data[9] <= 57'b0;
        cache_data[10] <= 57'b0;
        cache_data[11] <= 57'b0;
        cache_data[12] <= 57'b0;
        cache_data[13] <= 57'b0;
        cache_data[14] <= 57'b0;
        cache_data[15] <= 57'b0;
        cache_data[16] <= 57'b0;
        cache_data[17] <= 57'b0;
        cache_data[18] <= 57'b0;
        cache_data[19] <= 57'b0;
        cache_data[20] <= 57'b0;
        cache_data[21] <= 57'b0;
        cache_data[22] <= 57'b0;
        cache_data[23] <= 57'b0;
        cache_data[24] <= 57'b0;
        cache_data[25] <= 57'b0;
        cache_data[26] <= 57'b0;
        cache_data[27] <= 57'b0;
        cache_data[28] <= 57'b0;
        cache_data[29] <= 57'b0;
        cache_data[30] <= 57'b0;
        cache_data[31] <= 57'b0;
        cache_data[32] <= 57'b0;
        cache_data[33] <= 57'b0;
        cache_data[34] <= 57'b0;
        cache_data[35] <= 57'b0;
        cache_data[36] <= 57'b0;
        cache_data[37] <= 57'b0;
        cache_data[38] <= 57'b0;
        cache_data[39] <= 57'b0;
        cache_data[40] <= 57'b0;
        cache_data[41] <= 57'b0;
        cache_data[42] <= 57'b0;
        cache_data[43] <= 57'b0;
        cache_data[44] <= 57'b0;
        cache_data[45] <= 57'b0;
        cache_data[46] <= 57'b0;
        cache_data[47] <= 57'b0;
        cache_data[48] <= 57'b0;
        cache_data[49] <= 57'b0;
        cache_data[50] <= 57'b0;
        cache_data[51] <= 57'b0;
        cache_data[52] <= 57'b0;
        cache_data[53] <= 57'b0;
        cache_data[54] <= 57'b0;
        cache_data[55] <= 57'b0;
        cache_data[56] <= 57'b0;
        cache_data[57] <= 57'b0;
        cache_data[58] <= 57'b0;
        cache_data[59] <= 57'b0;
        cache_data[60] <= 57'b0;
        cache_data[61] <= 57'b0;
        cache_data[62] <= 57'b0;
        cache_data[63] <= 57'b0;
    end
    /*-------------------------------cache memoory-------------------------------*/
    
    /*-------------------------------read logic-------------------------------*/
    assign data_in_cache = (cache_data[raddr[5:0]][55:32] == raddr[29:6]) & cache_data[raddr[5:0]][56];
    assign rdata = cache_data[raddr[5:0]][31:0];
    /*-------------------------------read logic-------------------------------*/
    
    /*-------------------------------write logic-------------------------------*/
    always @(posedge clk) begin
        if (resetn) begin
            if (clear) begin
                cache_data[waddr[5:0]] <= 57'b0;
            end
            else begin
                if (wen) begin
                    cache_data[waddr[5:0]] <= {1'b1, waddr[29:6], wdata};
                end
            end
        end
        else begin
            cache_data[0] <= 57'b0;
            cache_data[1] <= 57'b0;
            cache_data[2] <= 57'b0;
            cache_data[3] <= 57'b0;
            cache_data[4] <= 57'b0;
            cache_data[5] <= 57'b0;
            cache_data[6] <= 57'b0;
            cache_data[7] <= 57'b0;
            cache_data[8] <= 57'b0;
            cache_data[9] <= 57'b0;
            cache_data[10] <= 57'b0;
            cache_data[11] <= 57'b0;
            cache_data[12] <= 57'b0;
            cache_data[13] <= 57'b0;
            cache_data[14] <= 57'b0;
            cache_data[15] <= 57'b0;
            cache_data[16] <= 57'b0;
            cache_data[17] <= 57'b0;
            cache_data[18] <= 57'b0;
            cache_data[19] <= 57'b0;
            cache_data[20] <= 57'b0;
            cache_data[21] <= 57'b0;
            cache_data[22] <= 57'b0;
            cache_data[23] <= 57'b0;
            cache_data[24] <= 57'b0;
            cache_data[25] <= 57'b0;
            cache_data[26] <= 57'b0;
            cache_data[27] <= 57'b0;
            cache_data[28] <= 57'b0;
            cache_data[29] <= 57'b0;
            cache_data[30] <= 57'b0;
            cache_data[31] <= 57'b0;
            cache_data[32] <= 57'b0;
            cache_data[33] <= 57'b0;
            cache_data[34] <= 57'b0;
            cache_data[35] <= 57'b0;
            cache_data[36] <= 57'b0;
            cache_data[37] <= 57'b0;
            cache_data[38] <= 57'b0;
            cache_data[39] <= 57'b0;
            cache_data[40] <= 57'b0;
            cache_data[41] <= 57'b0;
            cache_data[42] <= 57'b0;
            cache_data[43] <= 57'b0;
            cache_data[44] <= 57'b0;
            cache_data[45] <= 57'b0;
            cache_data[46] <= 57'b0;
            cache_data[47] <= 57'b0;
            cache_data[48] <= 57'b0;
            cache_data[49] <= 57'b0;
            cache_data[50] <= 57'b0;
            cache_data[51] <= 57'b0;
            cache_data[52] <= 57'b0;
            cache_data[53] <= 57'b0;
            cache_data[54] <= 57'b0;
            cache_data[55] <= 57'b0;
            cache_data[56] <= 57'b0;
            cache_data[57] <= 57'b0;
            cache_data[58] <= 57'b0;
            cache_data[59] <= 57'b0;
            cache_data[60] <= 57'b0;
            cache_data[61] <= 57'b0;
            cache_data[62] <= 57'b0;
            cache_data[63] <= 57'b0;
        end
    end
    /*-------------------------------write logic-------------------------------*/
endmodule
