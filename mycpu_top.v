`timescale 1ns / 1ps

//mycpu_top
module mycpu_top(
    input [ 5:0] ext_int       ,   //high active

    input aclk                 ,
    input aresetn              ,   //low active

    //axi
    //ar
    output [3 :0] arid         ,
    output [31:0] araddr       ,
    output [7 :0] arlen        ,
    output [2 :0] arsize       ,
    output [1 :0] arburst      ,
    output [1 :0] arlock       ,
    output [3 :0] arcache      ,
    output [2 :0] arprot       ,
    output        arvalid      ,
    input         arready      ,
    //r           
    input  [3 :0] rid          ,
    input  [31:0] rdata        ,
    input  [1 :0] rresp        ,
    input         rlast        ,
    input         rvalid       ,
    output        rready       ,
    //aw          
    output [3 :0] awid         ,
    output [31:0] awaddr       ,
    output [7 :0] awlen        ,
    output [2 :0] awsize       ,
    output [1 :0] awburst      ,
    output [1 :0] awlock       ,
    output [3 :0] awcache      ,
    output [2 :0] awprot       ,
    output        awvalid      ,
    input         awready      ,
    //w          
    output [3 :0] wid          ,
    output [31:0] wdata        ,
    output [3 :0] wstrb        ,
    output        wlast        ,
    output        wvalid       ,
    input         wready       ,
    //b           
    input  [3 :0] bid          ,
    input  [1 :0] bresp        ,
    input         bvalid       ,
    output        bready       ,

    //degug信号，供验证平台使用
	output [31:0] debug_wb_pc,//写回级PC，需要将PC一路带到写回级
	output [ 3:0] debug_wb_rf_wen,//写回级写寄存器堆的写使能，为字节写使能。
	output [ 4:0] debug_wb_rf_wnum,//写回级写寄存器堆的目的寄存器号
	output [31:0] debug_wb_rf_wdata //写回级写寄存器堆的写数据
);
//inst sram-like 
wire         inst_req     ;
wire         inst_wr      ;
wire  [1 :0] inst_size    ;
wire  [31:0] inst_addr    ;
wire  [31:0] inst_wdata   ;
wire  [31:0] inst_rdata   ;
wire         inst_addr_ok ;
wire         inst_data_ok ;
    
//data sram-like 
wire         data_req     ;
wire         data_wr      ;
wire  [1 :0] data_size    ;
wire  [31:0] data_addr    ;
wire  [31:0] data_wdata   ;
wire  [31:0] data_rdata   ;
wire         data_addr_ok ;
wire         data_data_ok ;

/*
//debug signals
wire [31:0] debug_wb_pc      ;
wire [3 :0] debug_wb_rf_wen  ;
wire [4 :0] debug_wb_rf_wnum ;
wire [31:0] debug_wb_rf_wdata;

//axi
//ar
wire [3 :0] arid          ;
wire [31:0] araddr        ;
wire [7 :0] arlen         ;
wire [2 :0] arsize        ;
wire [1 :0] arburst       ;
wire [1 :0] arlock        ;
wire [3 :0] arcache       ;
wire [2 :0] arprot        ;
wire        arvalid       ;
wire        arready       ;
//r           
wire [3 :0] rid           ;
wire [31:0] rdata         ;
wire [1 :0] rresp         ;
wire        rlast         ;
wire        rvalid        ;
wire        rready        ;
//aw          
wire [3 :0] awid          ;
wire [31:0] awaddr        ;
wire [7 :0] awlen         ;
wire [2 :0] awsize        ;
wire [1 :0] awburst       ;
wire [1 :0] awlock        ;
wire [3 :0] awcache       ;
wire [2 :0] awprot        ;
wire        awvalid       ;
wire        awready       ;
//w          
wire [3 :0] wid           ;
wire [31:0] wdata         ;
wire [3 :0] wstrb         ;
wire        wlast         ;
wire        wvalid        ;
wire        wready        ;
//b           
wire [3 :0] bid           ;
wire [1 :0] bresp         ;
wire        bvalid        ;
wire        bready        ;
*/

sram_like_cpu sram_like_cpu(
    .clk          (aclk),
    .resetn       (aresetn), 
    .ext_int      (ext_int),

    //inst sram-like 
    .inst_req     (inst_req),
    .inst_wr      (inst_wr),
    .inst_size    (inst_size),
    .inst_addr    (inst_addr),
    .inst_wdata   (inst_wdata),
    .inst_rdata   (inst_rdata),
    .inst_addr_ok (inst_addr_ok),
    .inst_data_ok (inst_data_ok),
    
    //data sram-like 
    .data_req     (data_req),
    .data_wr      (data_wr),
    .data_size    (data_size),
    .data_addr    (data_addr),
    .data_wdata   (data_wdata),
    .data_rdata   (data_rdata),
    .data_addr_ok (data_addr_ok),
    .data_data_ok (data_data_ok),

    //debug interface
    .debug_wb_pc      (debug_wb_pc      ),
    .debug_wb_rf_wen  (debug_wb_rf_wen  ),
    .debug_wb_rf_wnum (debug_wb_rf_wnum ),
    .debug_wb_rf_wdata(debug_wb_rf_wdata)
);

cpu_axi_interface cpu_axi_interface(
    .clk        (aclk),
    .resetn     (aresetn), 

    //inst sram-like 
    .inst_req     (inst_req),
    .inst_wr      (inst_wr),
    .inst_size    (inst_size),
    .inst_addr    (inst_addr),
    .inst_wdata   (inst_wdata),
    .inst_rdata   (inst_rdata),
    .inst_addr_ok  (inst_addr_ok),
    .inst_data_ok (inst_data_ok),
    
    //data sram-like 
    .data_req     (data_req),
    .data_wr      (data_wr),
    .data_size    (data_size),
    .data_addr    (data_addr),
    .data_wdata   (data_wdata),
    .data_rdata   (data_rdata),
    .data_addr_ok (data_addr_ok),
    .data_data_ok (data_data_ok),

    //axi
    //ar
    .arid         (arid),
    .araddr       (araddr),
    .arlen        (arlen),
    .arsize       (arsize),
    .arburst      (arburst),
    .arlock       (arlock),
    .arcache      (arcache),
    .arprot       (arprot),
    .arvalid      (arvalid),
    .arready      (arready),
    //r           
    .rid          (rid),
    .rdata        (rdata),
    .rresp        (rresp),
    .rlast        (rlast),
    .rvalid       (rvalid),
    .rready       (rready),
    //aw          
    .awid         (awid),
    .awaddr       (awaddr),
    .awlen        (awlen),
    .awsize       (awsize),
    .awburst      (awburst),
    .awlock       (awlock),
    .awcache      (awcache),
    .awprot       (awprot),
    .awvalid      (awvalid),
    .awready      (awready),
    //w          
    .wid          (wid),
    .wdata        (wdata),
    .wstrb        (wstrb),
    .wlast        (wlast),
    .wvalid       (wvalid),
    .wready       (wready),
    //b           
    .bid          (bid),
    .bresp        (bresp),
    .bvalid       (bvalid),
    .bready       (bready)
);

endmodule