`include "defines.v"
module mioc(
            input wire ior_ctl_i,
            input wire iow_ctl_i,
            input wire mw_ctl_i,
            input wire mr_ctl_i,
            
            input wire[`RegBus] wm_idata_i,
            input wire[`RegBus] m_iaddr_i,
            

            input wire[`RegBus] rmemdata_i,
            output reg[`RegBus] wrmemdata_o,
            output reg[`RegBus] memaddr_o,            
            output reg memwenb_o,
            output reg mem_ce,
            output reg[3:0] mem_sel_o,
            
            
            input wire[`RegBus] wiodata_i,            
            output reg[`RegBus] wiodata,
            output reg iowenb_o,
            output reg io_ce,
            output reg[`RegBus] ioaddr,
            
            output reg[`RegBus] rm_idata
);
  wire[3:0] Chip_Ctrler;
  assign Chip_Ctrler = {ior_ctl_i,iow_ctl_i,mw_ctl_i,mr_ctl_i};

  always @(*)
  begin
    wrmemdata_o <= `ZeroWord;
    memaddr_o <= `ZeroWord;
    memwenb_o <= `WriteDisable;
    mem_ce <= `ChipDisable;
    mem_sel_o <= 4'b0000;
    
    wiodata <= `ZeroWord;
    iowenb_o <= `WriteDisable;
    io_ce <= `ChipDisable;
    ioaddr <= `ZeroWord;
    rm_idata <= `ZeroWord;
    mem_sel_o <= 4'b0000; 
    
    case(Chip_Ctrler)
      4'b1000: begin //ior_ctl_i
        iowenb_o <= `WriteDisable;
        io_ce <= `ChipEnable;
        ioaddr <= m_iaddr_i;
        rm_idata <= wiodata_i;
      end
      4'b0100: begin //iow_ctl_i
        iowenb_o <= `WriteEnable;
        io_ce <= `ChipEnable;
        ioaddr <= m_iaddr_i;
        wiodata <= wm_idata_i;
      end
      4'b0010: begin //mw_ctl_i
        memwenb_o <= 1'b0;   //write
        mem_ce <= `ChipEnable;
        memaddr_o <= m_iaddr_i;
        wrmemdata_o <= wm_idata_i;
        mem_sel_o <= 4'b1111;
        
      end
      4'b0001: begin //mr_ctl_i
        memwenb_o <= 1'b1;   //read 
        mem_ce <= `ChipEnable;
        memaddr_o <= m_iaddr_i;
        rm_idata <= rmemdata_i;
        mem_sel_o <= 4'b1111;
      end
      default: begin
      end
    endcase    
  end
endmodule
