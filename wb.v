`include "defines.v"
module wb(
	input wire										rst,
	

	//����EX����Ϣ	
	input wire[`RegAddrBus]       ex_wd,
	input wire                    ex_wreg,
	input wire[`RegBus]			  ex_wdata,

	//�͵�Regfile����Ϣ
	output reg[`RegAddrBus]      wb_wd,
	output reg                   wb_wreg,
	output reg[`RegBus]					 wb_wdata	       
	
);

	always @ (*) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;	
		end else begin
			wb_wd <= ex_wd;
			wb_wreg <= ex_wreg;
			wb_wdata <= ex_wdata;
		end    //if
	end      //always
			

endmodule
