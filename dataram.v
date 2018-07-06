`include "defines.v"
module data_ram(
    input wire clk,
    input wire ce,
    input wire we,
    input wire[`DataAddrBus] addr,
	/*sell用于片选4个8位dataram，但目前实现的最基本的设计不涉及片选，
	留作以后扩展用*/
    input wire[3:0] sell,
    input wire[`DataBus] data_i,
    output reg[`DataBus] data_o
);
  /*4组8位构成一组32位dataram*/
  reg[`ByteWidth] data_mem0[0:`DataMemNum-1];
  reg[`ByteWidth] data_mem1[0:`DataMemNum-1];
  reg[`ByteWidth] data_mem2[0:`DataMemNum-1];
  reg[`ByteWidth] data_mem3[0:`DataMemNum-1];
  always@(posedge clk)
  begin
    if(ce == `ChipDisable)  begin
      
    end
    else if(we == `WriteEnable) 
    begin
      if(sell[3] == 1'b1)  begin
        data_mem3[addr] = data_i[31:24];
      end
      if(sell[2] == 1'b1)  begin
        data_mem2[addr] = data_i[23:16];
      end
      if(sell[1] == 1'b1)  begin
        data_mem1[addr] = data_i[15:8];
      end
      if(sell[0] == 1'b1)  begin
        data_mem0[addr] = data_i[7:0];
      end
    end
  end
  
  always@(*) 
  begin
    if(ce == `ChipDisable) begin
      data_o = `ZeroWord;
    end
    else if(we == `WriteDisable)  
    begin
      data_o = {data_mem3[addr],
                 data_mem2[addr],
                 data_mem1[addr],
                 data_mem0[addr]};
    end
    else begin
      data_o = `ZeroWord;
    end
  end
endmodule