`include "defines.v"
module pc_reg(
	input wire					clk,
	input wire					rst,
	input wire                  PCWre, //haltָ����Ҫ����PC
	input wire                  PCSrc,
	input wire[`InstAddrBus]    branch_addr,
	
	output reg[`InstAddrBus]    pc,
	output reg					ce
);


always @(posedge clk or negedge rst)
  begin
	if(rst==`RstEnable) begin
		ce <=`ChipDisable;		//��λʱָ��洢������
		pc<=32'h00000000;		//ָ��洢������ʱ��pcΪ0
	end
	else if(PCWre) begin
		ce<=`ChipEnable;		//��λ����ʹ��ָ��洢��
		if (PCSrc) pc <= branch_addr;
		else       pc <= pc + 4'h4;
	end
	else  begin
	    pc <= pc;  //haltָ�ͣ����pc���ֲ���
    end
  end


endmodule