`include "defines.v"
module wb(
	input wire					  rst,
	
	//来自ex中的rt的数据
	input wire[`RegBus]           reg2_data_i,
	
	//来自EX的信息	
	input wire[`RegAddrBus]       ex_waddr,
	input wire                    ex_wreg,
	input wire[`RegBus]			        ex_wdata,
	//来自ID的信息
	input wire                    DataMemRW,
    input wire                  ALUM2Reg,

	//送到Regfile的信息
	output reg[`RegAddrBus]       wb_waddr,
	output reg                    wb_wreg,
	output reg[`RegBus]			        wb_wdata,

	//来自MIOC的信息，读入的数据，RAM或button或键盘
	input wire[`RegBus]           rm_idata,
    //送到MIOC的信息
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
				wb_wdata = rm_idata;  //写往regfile的数据，来自ram
			  end
			else if(DataMemRW == 1)  //sw
			  begin
			    mw     = 1'b1;
			    mr     = 1'b0;
				m_iaddr  = ex_wdata;
				wm_idata   = reg2_data_i;   //rt的数据
			  end
			else
			  begin
			   wb_wdata = ex_wdata;
			  end
		end    
	end  

endmodule
