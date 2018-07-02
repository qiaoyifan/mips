`include "defines.v"
module wb(
	input wire					  rst,
	
	//����ex�е�rt������
	input wire[`RegBus]           reg2_data_i,
	
	//����EX����Ϣ	
	input wire[`RegAddrBus]       ex_waddr,
	input wire                    ex_wreg,
	input wire[`RegBus]			        ex_wdata,
	//����ID����Ϣ
	input wire                    DataMemRW,
    input wire                  ALUM2Reg,

	//�͵�Regfile����Ϣ
	output reg[`RegAddrBus]       wb_waddr,
	output reg                    wb_wreg,
	output reg[`RegBus]			        wb_wdata,

	//����MIOC����Ϣ����������ݣ�RAM��button�����
	input wire[`RegBus]           rm_idata,
    //�͵�MIOC����Ϣ
  output reg                    io_r,
	output reg                    io_w,
	output reg[`RegBus]           wm_idata,
	output reg[`RegBus]           m_iaddr,
	output reg                    mw,
	output reg                    mr
	
	
);

  reg [31:0] DataMem [0:31];
  //reg [31:0] DataOut;
	always @ (*) begin
		if(rst == `RstEnable) begin
			wb_waddr     <= `NOPRegAddr;
			wb_wreg   <= `WriteDisable;
		    wb_wdata  <= `ZeroWord;	
		end 
		else begin
		  io_r = 1'b0;
		  io_w = 1'b0;
		   wb_waddr = ex_waddr;
		   wb_wreg  = ex_wreg;
			if (ALUM2Reg == 1) //lw
			  begin
			    mr       = 1'b1;
			    mw       = 1'b0;
				m_iaddr  = ex_wdata;
				wb_wdata = rm_idata;  //д��regfile�����ݣ�����ram
			  end
			else if(DataMemRW == 1)  //sw
			  begin
			    mw     = 1'b1;
			    mr     = 1'b0;
				m_iaddr  = ex_wdata;
				wm_idata   = reg2_data_i;   //rt������
			  end
			else
			  begin
			   wb_wdata = ex_wdata;
			  end
		end    
	end  

endmodule
