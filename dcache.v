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
    input  [31:0] raddr,
    input         clear,
    input         wen,
    input  [31:0] waddr,
    input  [31:0] wdata,
    output [31:0] rdata,
    output        data_in_cache
    );
    /*-------------------------------cache memoory-------------------------------*/
    reg [58:0] cache_data [63:0];
    initial begin
        cache_data[0] <= 59'b0;
        cache_data[1] <= 59'b0;
        cache_data[2] <= 59'b0;
        cache_data[3] <= 59'b0;
        cache_data[4] <= 59'b0;
        cache_data[5] <= 59'b0;
        cache_data[6] <= 59'b0;
        cache_data[7] <= 59'b0;
        cache_data[8] <= 59'b0;
        cache_data[9] <= 59'b0;
        cache_data[10] <= 59'b0;
        cache_data[11] <= 59'b0;
        cache_data[12] <= 59'b0;
        cache_data[13] <= 59'b0;
        cache_data[14] <= 59'b0;
        cache_data[15] <= 59'b0;
        cache_data[16] <= 59'b0;
        cache_data[17] <= 59'b0;
        cache_data[18] <= 59'b0;
        cache_data[19] <= 59'b0;
        cache_data[20] <= 59'b0;
        cache_data[21] <= 59'b0;
        cache_data[22] <= 59'b0;
        cache_data[23] <= 59'b0;
        cache_data[24] <= 59'b0;
        cache_data[25] <= 59'b0;
        cache_data[26] <= 59'b0;
        cache_data[27] <= 59'b0;
        cache_data[28] <= 59'b0;
        cache_data[29] <= 59'b0;
        cache_data[30] <= 59'b0;
        cache_data[31] <= 59'b0;
        cache_data[32] <= 59'b0;
        cache_data[33] <= 59'b0;
        cache_data[34] <= 59'b0;
        cache_data[35] <= 59'b0;
        cache_data[36] <= 59'b0;
        cache_data[37] <= 59'b0;
        cache_data[38] <= 59'b0;
        cache_data[39] <= 59'b0;
        cache_data[40] <= 59'b0;
        cache_data[41] <= 59'b0;
        cache_data[42] <= 59'b0;
        cache_data[43] <= 59'b0;
        cache_data[44] <= 59'b0;
        cache_data[45] <= 59'b0;
        cache_data[46] <= 59'b0;
        cache_data[47] <= 59'b0;
        cache_data[48] <= 59'b0;
        cache_data[49] <= 59'b0;
        cache_data[50] <= 59'b0;
        cache_data[51] <= 59'b0;
        cache_data[52] <= 59'b0;
        cache_data[53] <= 59'b0;
        cache_data[54] <= 59'b0;
        cache_data[55] <= 59'b0;
        cache_data[56] <= 59'b0;
        cache_data[57] <= 59'b0;
        cache_data[58] <= 59'b0;
        cache_data[59] <= 59'b0;
        cache_data[60] <= 59'b0;
        cache_data[61] <= 59'b0;
        cache_data[62] <= 59'b0;
        cache_data[63] <= 59'b0;
    end
    /*-------------------------------cache memoory-------------------------------*/
    
    /*-------------------------------read logic-------------------------------*/
    assign data_in_cache = (cache_data[raddr[5:0]][57:32] == raddr[31:6]) & cache_data[raddr[5:0]][58];
    assign rdata = cache_data[raddr[5:0]][31:0];
    /*-------------------------------read logic-------------------------------*/
    
    /*-------------------------------write logic-------------------------------*/
    always @(posedge clk) begin
        if (resetn) begin
            if (clear) begin
                cache_data[waddr[5:0]] <= 59'b0;
            end
            else begin
                if (wen) begin
                    cache_data[waddr[5:0]] <= {1'b1, waddr[31:6], wdata};
                end
            end
        end
        else begin
            cache_data[0] <= 59'b0;
            cache_data[1] <= 59'b0;
            cache_data[2] <= 59'b0;
            cache_data[3] <= 59'b0;
            cache_data[4] <= 59'b0;
            cache_data[5] <= 59'b0;
            cache_data[6] <= 59'b0;
            cache_data[7] <= 59'b0;
            cache_data[8] <= 59'b0;
            cache_data[9] <= 59'b0;
            cache_data[10] <= 59'b0;
            cache_data[11] <= 59'b0;
            cache_data[12] <= 59'b0;
            cache_data[13] <= 59'b0;
            cache_data[14] <= 59'b0;
            cache_data[15] <= 59'b0;
            cache_data[16] <= 59'b0;
            cache_data[17] <= 59'b0;
            cache_data[18] <= 59'b0;
            cache_data[19] <= 59'b0;
            cache_data[20] <= 59'b0;
            cache_data[21] <= 59'b0;
            cache_data[22] <= 59'b0;
            cache_data[23] <= 59'b0;
            cache_data[24] <= 59'b0;
            cache_data[25] <= 59'b0;
            cache_data[26] <= 59'b0;
            cache_data[27] <= 59'b0;
            cache_data[28] <= 59'b0;
            cache_data[29] <= 59'b0;
            cache_data[30] <= 59'b0;
            cache_data[31] <= 59'b0;
            cache_data[32] <= 59'b0;
            cache_data[33] <= 59'b0;
            cache_data[34] <= 59'b0;
            cache_data[35] <= 59'b0;
            cache_data[36] <= 59'b0;
            cache_data[37] <= 59'b0;
            cache_data[38] <= 59'b0;
            cache_data[39] <= 59'b0;
            cache_data[40] <= 59'b0;
            cache_data[41] <= 59'b0;
            cache_data[42] <= 59'b0;
            cache_data[43] <= 59'b0;
            cache_data[44] <= 59'b0;
            cache_data[45] <= 59'b0;
            cache_data[46] <= 59'b0;
            cache_data[47] <= 59'b0;
            cache_data[48] <= 59'b0;
            cache_data[49] <= 59'b0;
            cache_data[50] <= 59'b0;
            cache_data[51] <= 59'b0;
            cache_data[52] <= 59'b0;
            cache_data[53] <= 59'b0;
            cache_data[54] <= 59'b0;
            cache_data[55] <= 59'b0;
            cache_data[56] <= 59'b0;
            cache_data[57] <= 59'b0;
            cache_data[58] <= 59'b0;
            cache_data[59] <= 59'b0;
            cache_data[60] <= 59'b0;
            cache_data[61] <= 59'b0;
            cache_data[62] <= 59'b0;
            cache_data[63] <= 59'b0;
        end
    end
    /*-------------------------------write logic-------------------------------*/
endmodule
