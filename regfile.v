`timescale 1ns / 1ps

module regfile(
    input             clk,
    input             wen,
    input      [4 :0] raddr1,
    input      [4 :0] raddr2,
    input      [4 :0] waddr,
    input      [3 :0] rf_wbytes,
    input      [31:0] wdata,
    output     [31:0] rdata1,
    output     [31:0] rdata2,

    output [3:0]debug_wb_rf_wen,
    output [4:0]debug_wb_rf_wnum,
    output [31:0]debug_wb_rf_wdata 
    );
    reg [31:0] rf[31:0];
    assign debug_wb_rf_wen = rf_wbytes;
    assign debug_wb_rf_wdata = wdata;
    assign debug_wb_rf_wnum = waddr;
     
    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 0 hardwired to 0

    always @(posedge clk)
    begin
        if (wen && waddr != 5'b0) 
        begin
            if (rf_wbytes[3])
            begin
                rf[waddr][31:24] <= wdata[31:24];
            end
            if (rf_wbytes[2])
            begin
                rf[waddr][23:16] <= wdata[23:16];
            end
            if (rf_wbytes[1])
            begin
                rf[waddr][15:8] <= wdata[15:8];
            end
            if (rf_wbytes[0])
            begin
                rf[waddr][7:0] <= wdata[7:0];
            end
        end
    end
    assign rdata1 = (raddr1 == 5'b0)          ? 32'b0 : 
                    (raddr1 == waddr)&&(wen)  ? wdata :
                    rf[raddr1];
    assign rdata2 = (raddr2 == 5'b0)          ? 32'b0 : 
                    (raddr2 == waddr)&&(wen)  ? wdata :
                    rf[raddr2];
endmodule
