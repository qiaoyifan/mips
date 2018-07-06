`include "defines.v"
module wb(
	input wire					  rst,
	
	//��ex���յ���rt������
	input wire[`RegBus]           reg2_data_i,
	
	//����EX������	
	input wire[`RegAddrBus]       ex_waddr,
	input wire                    ex_wreg,
	input wire[`RegBus]			  ex_wdata,
	//����ID������
	input wire                    DataMemRW,
    input wire                    ALUM2Reg,

	//����Regfile������
	output reg[`RegAddrBus]       wb_waddr,
	output reg                    wb_wreg,
	output reg[`RegBus]			  wb_wdata,

	//��dataram�ͻص�����
	input wire[`RegBus]           rm_idata,
    //����MIOC������
    output reg                    io_r,
	output reg                    io_w,
	output reg[`RegBus]           wm_idata,
	output reg[`RegBus]           m_iaddr,
	output reg                    mw,
	output reg                    mr
	
	
);

  //reg [31:0] DataMem [0:31];
  //reg [31:0] DataOut;
	always @ (*) begin
		if(rst == `RstEnable) begin
			wb_waddr     = `NOPRegAddr;
			wb_wreg   = `WriteDisable;
		  wb_wdata  = `ZeroWord;	
		  m_iaddr   = `ZeroWord;
		  wm_idata  = `ZeroWord;
		end 
		else 
		begin
		  io_r = 1'b0;
		  io_w = 1'b0;
		  mw   = 1'b0;
		  mr   = 1'b0;
		   wb_waddr = ex_waddr;
		   wb_wreg  = ex_wreg;
		   wb_wdata = ex_wdata;
		   m_iaddr   = `ZeroWord;
		   wm_idata  = `ZeroWord;
			if (ALUM2Reg == 1) //lw
			  begin
			    
				io_r     = (((ex_wdata & 32'hFFFF_F000) == 32'hFFFF_F000) ? 1'b1:1'b0);
				mr       = !io_r;
				m_iaddr  = ex_wdata;
				wb_wdata = rm_idata;  //����regfile�����ݣ�����ram
			  end
			else if(DataMemRW == 1)  //sw
			  begin
				io_w      = (((ex_wdata & 32'hFFFF_F000) == 32'hFFFF_F000) ? 1'b1:1'b0);
                mw        = !io_w;
				m_iaddr   = ex_wdata;
				wm_idata  = reg2_data_i;   //����rt������
			  end
		end    
	end  

endmodule
