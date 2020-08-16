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
    input  [31:0] raddr,
    input         wen,
    input  [31:0] waddr,
    input  [31:0] wdata,
    output [31:0] rdata,
    output        data_in_cache
    );
    /*-------------------------------cache memoory-------------------------------*/
    reg [57:0] cache_data [63:0];
    /*-------------------------------cache memoory-------------------------------*/
    
    /*-------------------------------read logic-------------------------------*/
    assign data_in_cache = cache_data[raddr[5:0]][57:32] == raddr[31:6];
    assign rdata = cache_data[raddr[5:0]];
    /*-------------------------------read logic-------------------------------*/
    
    /*-------------------------------write logic-------------------------------*/
    always @(posedge clk) begin
        if (wen) begin
            cache_data[waddr[5:0]] <= {waddr[31:6], wdata};
        end
    end
    /*-------------------------------write logic-------------------------------*/
endmodule
