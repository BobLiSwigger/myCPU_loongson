`timescale 1ns / 1ps

module mem(                          
    input              clk,          
    input              resetn,       
    input              cancel,
    input              MEM_valid,    
    input      [166:0] EXE_MEM_bus_r,
    output             MEM_over,     
    output     [160:0] MEM_WB_bus,   
      

    input              MEM_allow_in, 
    output     [  4:0] MEM_wdest,    
    output     [ 31:0] MEM__result,
    output             MEM_load, 
    output             MEM_valid_r,

    //hi&lo related
    input      [ 31:0] HI_data,
    input      [ 31:0] LO_data,
    input      [ 31:0] WB_hi_data,
    input      [ 31:0] WB_lo_data,
    input              WB_hi_write,
    input              WB_lo_write,
    //input              WB_mfc0,
    //input              WB_mtc0,
    input      [ 31:0] cp0r_status,
    input      [ 31:0] cp0r_cause,
    input      [ 31:0] cp0r_epc,
    input      [ 31:0] cp0r_badvaddr, 
    output             MEM_mfhi,
    output             MEM_mflo,
    output             MEM_hi_write,
    output             MEM_lo_write,
    output     [ 31:0] MEM_hi_data,
    output     [ 31:0] MEM_lo_data,

    // sram_like interface
    output             data_req,
    output  reg        data_wr,
    output  reg [1 :0] data_size,
    output      [31:0] data_addr,
    output  reg [31:0] data_wdata,
    input       [31:0] data_rdata,
    input              data_addr_ok,
    input              data_data_ok //  
);

    reg data_req_;
    wire inst_store;
    wire data_req_t;
    
    wire dcache_wen;
    wire data_in_cache;
    wire data_in_cache_t;
    wire [31:0] dcache_rdata;
    wire [31:0] dcache_wdata;
    wire dcache_clear;
    wire [29:0] dcache_waddr;
    dcache dcache_module(
        clk,
        (resetn | cancel),
        {data_addr[31:2]},
        dcache_clear,
        dcache_wen,
        dcache_waddr,
        dcache_wdata,
        dcache_rdata,
        data_in_cache_t
    );
    

    always @(posedge clk)    
    begin
        if(MEM_over | resetn)
        begin
            data_req_ <= 1'b1;
        end
        else if(MEM_valid && !data_addr_ok && data_req_)
        begin
            data_req_ <= 1'b1;
        end
        else if(data_addr_ok)
        begin
            data_req_ <= 1'b0;
        end
    end

    wire inst_jbr;

    wire [4 :0] mem_control;  
    wire [31:0] store_data;   
    

    wire [31:0] exe_result;
    wire [31:0] lo_result;
    
	

    wire mtc0;
    wire mfc0;
    wire [7 :0] cp0r_addr;
    wire       syscall;   
    wire       break;
    wire       eret;
    wire       rf_wen;    
    wire [4:0] rf_wdest;
    wire [3:0] rf_wbytes;
    wire       ls_bytes_L;
    wire       ls_bytes_R;
    wire       ov_ex;
    wire       ri_ex;
    //pc
    wire [31:0] pc;  
    wire        inst_SB;
    assign {inst_jbr,
            mem_control,
            store_data,
            exe_result,
            lo_result,
            MEM_hi_write,
            MEM_lo_write,
            MEM_mfhi,
            MEM_mflo,
            mtc0,
            mfc0,
            cp0r_addr,
            syscall,
            break,
            ov_ex,
            ri_ex,
            eret,
            rf_wen,
            rf_wdest,
            pc,
            ls_bytes_L,
            ls_bytes_R,
            rf_wbytes,
            inst_SB         } = EXE_MEM_bus_r;  

    wire inst_load_t;  
     
    wire inst_store_t;
    wire ls_word;    
    wire ls_dbyte;
    wire l_unsign;    
    assign {inst_load_t,inst_store_t,ls_word,ls_dbyte, l_unsign} = mem_control;
 
    assign data_addr = exe_result & 32'H1fffffff;
    assign MEM_load = inst_load_t & ((ls_word & data_addr[1:0] == 2'b0) | (ls_dbyte & data_addr[0] == 1'b0) | (~ls_word & ~ls_dbyte)) & MEM_valid;
    assign inst_store = inst_store_t & ((ls_word & data_addr[1:0] == 2'b0) | (ls_dbyte & data_addr[0] == 1'b0) | (~ls_word & ~ls_dbyte) | (ls_dbyte & (ls_bytes_L | ls_bytes_R)));
 
    assign dcache_wen = ~cancel & ls_word & ~ls_dbyte & ~inst_SB & ((data_req & data_wr) | (data_req & ~data_wr & data_data_ok));
    assign data_req_t = (!MEM_valid)                 ?    1'b0    :
                        (!MEM_load && !inst_store)   ?    1'b0    :
                        data_req_;
    assign data_in_cache = (ls_word & ~ls_dbyte & ~inst_SB & MEM_valid & ~cancel) ? (data_in_cache_t) : 1'b0;//cache is valid only if load word rather than byte
    assign data_req = ~data_req_t ? 1'b0 : 
                      data_wr ? 1'b1 : 
                      data_in_cache ? 1'b0 : 
                      1'b1;
    assign dcache_wdata = data_wr ? data_wdata : data_rdata;
    assign dcache_clear = (inst_SB | ls_dbyte) & data_req_t & data_wr;
    assign dcache_waddr = {data_addr[31:2]};
 
    always @ (*)    
    begin
        if (MEM_valid && inst_store && !cancel) 
        begin
            if (ls_word)
            begin
                //dm_wen <= 4'b1111; 
                data_size <= 2'b10;//4bytes
                data_wr <= 1'b1;
            end
            else if(ls_dbyte)
            begin   
                /*
                case(data_addr[1:0])
                    2'b00   : dm_wen <= 4'b0011;
                    2'b10   : dm_wen <= 4'b1100;
                    default : dm_wen <= 4'b0000;
                endcase
                */
                if((data_addr[1:0] == 2'b00) || (data_addr[1:0] == 2'b10))
                begin
                    data_size <= 2'b01;//2byte
                    data_wr <= 1'b1;
                end
                else
                begin
                    data_wr <= 1'b0;                    
                end
            end
            else
            begin 
                /*
                case (data_addr[1:0])
                    2'b00   : dm_wen <= 4'b0001;
                    2'b01   : dm_wen <= 4'b0010;
                    2'b10   : dm_wen <= 4'b0100;
                    2'b11   : dm_wen <= 4'b1000;
                    default : dm_wen <= 4'b0000;
                endcase
                */
                data_size <= 2'b00;//1byte
                data_wr <= 1'b1;                
            end
        end
        //write req is as before
        else
        begin
            data_wr <= 1'b0;
        end
    end 
    
    
    always @ (*) 
    begin
        if (ls_bytes_L | ls_bytes_R) begin
            data_wdata <= store_data;
        end
        else begin
            case (data_addr[1:0])
                2'b00   : data_wdata <= store_data;
                2'b01   : data_wdata <= {16'd0, store_data[7:0], 8'd0};
                2'b10   : data_wdata <= {store_data[15:0], 16'd0};
                2'b11   : data_wdata <= {store_data[7:0], 24'd0};
                default : data_wdata <= store_data;
            endcase
        end
    end
    

    wire [31:0] load_result;
    wire [31:0] load_result_t;
    assign load_result_t = (data_req_t & ~data_req & ls_word & ~inst_SB) ? dcache_rdata : data_rdata;
    assign load_result  =   ls_word ? load_result_t : 
                            ls_dbyte & (data_addr[1:0] == 2'd0)   ?   {{16{~l_unsign & load_result_t[15]}}, load_result_t[15:0]}  :
                            ls_dbyte & (data_addr[1:0] == 2'd2)   ?   {{16{~l_unsign & load_result_t[31]}}, load_result_t[31:16]} :
                            data_addr[1:0] == 2'd0   ?   {{24{~l_unsign & load_result_t[7]}}, load_result_t[7:0]} :
                            data_addr[1:0] == 2'd1   ?   {{24{~l_unsign & load_result_t[15]}}, load_result_t[15:8]} :
                            data_addr[1:0] == 2'd2   ?   {{24{~l_unsign & load_result_t[23]}}, load_result_t[23:16]} :
                            {{24{~l_unsign & load_result_t[31]}}, load_result_t[31:24]};
                             

   
   /*
   always @(posedge clk)
   begin
       if (MEM_allow_in)
       begin
           MEM_valid_r <= 1'b0;
       end
       else
       begin
           MEM_valid_r <= MEM_valid;
       end
   end
   */
    assign MEM_valid_r = (!MEM_valid)                ?    1'b0    :
                         (!MEM_load && !inst_store)  ?    1'b0    :
                         (~data_req && data_req_t)   ?    1'b1    :
                         data_data_ok                ?    1'b1    :
                         1'b0;

   //assign MEM_over = MEM_load ? MEM_valid_r : MEM_valid;
    assign MEM_over = (!MEM_load && !inst_store)    ?  MEM_valid : 
                      (~data_req && data_req_t)     ?  1'b1      :
                      data_data_ok                  ?  1'b1      :
                      1'b0;


    wire adel_ex;
    wire ades_ex;
    wire MEM_wen;
    assign adel_ex = inst_load_t & ((ls_word & data_addr[1:0] != 2'b0) | (ls_dbyte & data_addr[0] != 1'b0));
    assign ades_ex = inst_store_t & ((ls_word & data_addr[1:0] != 2'b0) | (ls_dbyte & data_addr[0] != 1'b0));

    assign MEM_wdest = rf_wdest & {5{MEM_valid}};
    assign MEM_wen = rf_wen & ~adel_ex & ~ades_ex;



    wire [31:0] mem_result; 
    wire [31:0] cp0r_rdata;

    assign cp0r_rdata = (cp0r_addr=={5'd12,3'd0}) ? cp0r_status :
                        (cp0r_addr=={5'd13,3'd0}) ? cp0r_cause  :
                        (cp0r_addr=={5'd14,3'd0}) ? cp0r_epc : 
                        (cp0r_addr=={5'd08,3'd0}) ? cp0r_badvaddr : 32'd0;
   
    assign mem_result = MEM_load ? load_result : exe_result;
    assign MEM__result =(MEM_mflo & MEM_valid & WB_lo_write)  ? (WB_lo_data & {32{MEM_valid}}) :
                        (MEM_mflo & MEM_valid & !WB_lo_write) ? (LO_data & {32{MEM_valid}})    :
                        (MEM_mfhi & MEM_valid & WB_hi_write)  ? (WB_hi_data & {32{MEM_valid}}) :
                        (MEM_mfhi & MEM_valid & !WB_hi_write) ? (HI_data & {32{MEM_valid}})    :
                        (mfc0 & MEM_valid )                   ? (cp0r_rdata&{32{MEM_valid}}) : 
                        (ls_bytes_L | (rf_wbytes == 4'b1000)) ? {mem_result[7:0], 24'b0} & {32{MEM_valid}} : 
                        (ls_bytes_L | (rf_wbytes == 4'b1100)) ? {mem_result[15:0], 16'b0} & {32{MEM_valid}} : 
                        (ls_bytes_L | (rf_wbytes == 4'b1110)) ? {mem_result[23:0], 8'b0} & {32{MEM_valid}} : 
                        (ls_bytes_L | (rf_wbytes == 4'b1111)) ? mem_result & {32{MEM_valid}} : 
                        (ls_bytes_R | (rf_wbytes == 4'b1111)) ? mem_result & {32{MEM_valid}} : 
                        (ls_bytes_R | (rf_wbytes == 4'b0111)) ? {8'b0, mem_result[31:8]} & {32{MEM_valid}} : 
                        (ls_bytes_R | (rf_wbytes == 4'b0011)) ? {16'b0, mem_result[31:16]} & {32{MEM_valid}} : 
                        (ls_bytes_R | (rf_wbytes == 4'b0001)) ? {24'b0, mem_result[31:24]} & {32{MEM_valid}} : 
                        mem_result & {32{MEM_valid}};
	assign MEM_hi_data = mem_result;
    assign MEM_lo_data = lo_result;    
	assign MEM_WB_bus = {inst_jbr,MEM_wen,rf_wdest,                   
                         mem_result,                        
                         lo_result,                         
                         MEM_hi_write,MEM_lo_write,                 
                         MEM_mfhi,MEM_mflo,                         
                         mtc0,mfc0,cp0r_addr,syscall,break,ov_ex,adel_ex,ades_ex,ri_ex,eret, 
                         exe_result,
                         pc, rf_wbytes};                               // PC


endmodule

