`include "defines.v"
module io(
          input clk,
          input rst,
          input wire[`RegBus] addr,
          input wire ce,
          input wire iow,
          input wire[`RegBus] wdata,
          
          output reg[`RegBus] rdata,
          
          //IO devices
          output reg[`RegBus] Seg, //0xFFFFF000
          output reg[15:0] Led, //0xFFFFF004
          
          input wire[15:0] Sel, //0xFFFFF008
          input wire[15:0] Button //0xFFFFF012
);

//read

  always @(*)
  begin
    if(rst == `RstEnable)
      begin
        rdata = `ZeroWord;
      end
    else
      begin
        if( ce == `ChipEnable )
          begin
            case(addr)
              `KEY: 
              begin
                  rdata = {Sel,Sel};
              end
              `BUTTON: 
              begin
                  rdata = Button;
              end
            endcase
          end
      end
    end

  

//write
  always @ (posedge clk)
  begin
    if(rst == `RstEnable)
      begin
        Seg = `ZeroWord;
        Led = `ZeroWord;
      end
      else if( ce == `ChipEnable )
        begin
          case(addr)
            `SEG: begin
                Seg = wdata;
            end
            `LED: begin
                Led = wdata[15:0];
            end
          endcase
        end
    end
endmodule
