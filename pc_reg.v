`include "defines.v"
module pc_reg(
	input wire					clk,
	input wire					rst,
	input wire                  PCWre, //halt指令需要除能PC
	input wire                  PCSrc,
	input wire[`InstAddrBus]    branch_addr,
	
	output reg[`InstAddrBus]    pc,
	output reg					ce
);


always @(posedge clk or negedge rst)
  begin
	if(rst==`RstEnable) begin
		ce <=`ChipDisable;		//复位时指令存储器禁用
		pc<=32'h00000000;		//指令存储器禁用时，pc为0
	end
	else if(PCWre) begin
		ce<=`ChipEnable;		//复位结束使能指令存储器
		if (PCSrc) pc <= branch_addr;
		else       pc <= pc + 4'h4;
	end
	else  begin
	    pc <= pc;  //halt指令，停机，pc保持不变
    end
  end


endmodule