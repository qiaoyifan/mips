`include "defines.v"
`include "pc_reg.v"
`include "id.v"
`include "regfile.v"
`include "ex.v"
`include "wb.v"
module openmips(
    input wire          clk,
    input wire          rst,

    input wire[`RegBus]         rom_data_i,
    output wire[`RegBus]        rom_addr_o,
    output wire                 rom_ce_o,
	
	input wire[`RegBus]  ram_data_i,
	output wire[`RegBus] ram_addr_o,
	output wire[`RegBus] ram_data_o,
	output wire  ram_we_o,
	output wire[3:0] ram_sel_o,
	output wire  ram_ce_o,
	
	input wire[`RegBus]  io_data_i,
	output wire[`RegBus] io_addr_o,
	output wire[`RegBus] io_data_o,
	output wire  io_we_o,
	output wire  io_ce_o
	
);
//连接ID模块和EX模块
wire[`AluOpBus]   id_aluop;
wire[`AluSelBus]  id_alusel;
wire[`RegBus]     id_reg1;
wire[`RegBus]     id_reg2;
wire[`RegBus]     id_reg22;
wire              id_wreg;
wire[`RegAddrBus] id_waddr;
//连接ID模块和Regfile模块
wire              reg1_read;
wire              reg2_read;
wire[`RegBus]     reg1_data;
wire[`RegBus]     reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;
//连接ID和WB模块
wire              ALUM2Reg;
wire              DataMemRW;

//连接ID和PC模块
wire              PCWre;
wire              PCSrc;
wire[`RegBus]     branch_addr;

//连接EX模块和WB模块
wire              ex_wreg;
wire[`RegAddrBus] ex_waddr;
wire[`RegBus]     ex_wdata;
wire[`RegBus]     ex_reg2;

//连接EX模块和ID模块
wire              zero;

//连接WB模块和Regfile模块
wire[`RegAddrBus] wb_waddr;
wire              wb_wreg;
wire[`RegBus]     wb_wdata;

//连接WB模块和MIOC模块
wire	ior;
wire	iow;
wire	mw;
wire	mr;

wire[`RegBus]     wm_idata;
wire[`RegBus]     m_iaddr;
wire[`RegBus]     rme_idata;
wire[`RegBus] 	   wiodata;
//连接MIOC与WB
wire [`RegBus] rm_idata;

//连接MIOC与IO模块

wire[`RegBus] io_addr;
wire io_ce;
wire io_iow;
wire[`RegBus] wdata;
wire[`RegBus] rdata;

//连接IO与板子
//wire[`RegBus] Button;


//连接MIOC与DataMem Ram
wire [3:0] mem_sel;
wire mem_ce;//mem_ce
wire mem_we;//mem_we
wire [`RegBus]	mem_addr;//memaddr_o
wire [`RegBus]	wdata_o;//wrmemdata_o


mioc mioc0(
	//来自WB的输入
	.ior_ctl_i(ior),
	.iow_ctl_i(iow),
	.mw_ctl_i(mw),
	.mr_ctl_i(mr),
	.wm_idata_i(wm_idata),
	.m_iaddr_i(m_iaddr),

	//送到WB的输出
	.rm_idata(rm_idata),
	
	//来自dataMem的输入
	.rmemdata_i(ram_data_i),
	
	//送到mem的输出
	.wrmemdata_o(ram_data_o),
    .memaddr_o(ram_addr_o),            
    .memwenb_o(ram_we_o),
    .mem_ce(ram_ce_o),
    .mem_sel_o(ram_sel_o),
			  
	//来自IO的输入
	.wiodata_i(io_data_i),
	
	//送到IO模块的输出		  
	.wiodata(io_data_o),
	.iowenb_o(io_we_o),
    .io_ce(io_ce_o),
    .ioaddr(io_addr_o)
);
//连接外设
//wire[`RegBus] Seg; //0xFFFFF000
//wire[15:0] Led; //0xFFFFF004
//wire[1:0] Sel; //0xFFFFF008

/*
io io0(
	
	.clk(clk),
    .rst(rst),
	//来MIOC的输入
    .addr(io_addr),
    .ce(io_ce),
    .iow(iow),
    .wdata(wiodata),
	//送到MIOC的输出
    .rdata(rdata),
	
	//送到外设的输出
    //IO devices
    .Seg(Seg), //0xFFFFF000
    .Led(Led), //0xFFFFF004
	//来自外设的输出
    .Sel(Sel), //0xFFFFF008
    .Button(Button) //0xFFFFF012	
);
*/

//pc_reg real
pc_reg pc_reg0(
    .clk(clk),  .rst(rst),  .pc(rom_addr_o),    .ce(rom_ce_o),
	.PCWre(PCWre), .PCSrc(PCSrc), .branch_addr(branch_addr)
);
//ID real
id id0(
    .rst(rst),  
    .pc_i(rom_addr_o), 
    .instruction(rom_data_i),
    //来自Regfile模块的输入
    .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),
    //送到Regfile模块的信息
    .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr),
    //送到EX模块的信息
    .aluop_o(id_aluop),   .alusel_o(id_alusel),
    .reg1_o(id_reg1),     .reg2_o(id_reg2),
	.reg2_oo(id_reg22),
    .waddr_o(id_waddr),         .wreg_o(id_wreg),
	//送到PC模块信息
	.PCSrc(PCSrc),    .PCWre(PCWre),
	.branch_addr(branch_addr),
	//送到WB模块的信息
	.ALUM2Reg(ALUM2Reg), .DataMemRW(DataMemRW),
	//来自EX模块的信息
	.zero(zero)
);
//Regfile real
regfile regfile1(
    .clk(clk),
    .rst(rst),
    //从WB模块传来信息
    .we(wb_wreg), .waddr(wb_waddr),
    .wdata(wb_wdata),
    //ID模块传来的信息
    .re1(reg1_read),    .raddr1(reg1_addr), 
    .rdata1(reg1_data),
    .re2(reg2_read),    .raddr2(reg2_addr),
    .rdata2(reg2_data)
);
//EX real
ex ex0(
    .rst(rst),
    //从ID模块传来的信息
    .aluop_i(id_aluop),   .alusel_i(id_alusel),
    .reg1_i(id_reg1),     .reg2_i(id_reg2),
	.reg2_ii(id_reg22),
    .waddr_i(id_waddr),         .wreg_i(id_wreg),
    //送到WB模块的信息
    .waddr_o(ex_waddr),      .wreg_o(ex_wreg),
    .wdata_o(ex_wdata),   .reg2_o(ex_reg2),
	.zero(zero)
);
//WB real
wb wb0(
    .rst(rst),
	//来自EX模块的信息
    .ex_waddr(ex_waddr),         .ex_wreg(ex_wreg),
    .ex_wdata(ex_wdata),         .reg2_data_i(ex_reg2),
	
    .wb_waddr(wb_waddr),         .wb_wreg(wb_wreg),
    .wb_wdata(wb_wdata),
	//来自ID模块的信息
	.ALUM2Reg(ALUM2Reg),   .DataMemRW(DataMemRW),
	//送到MIOC模块的信息
	.io_r(ior),
	.io_w(iow),
	.wm_idata(wm_idata),
	.m_iaddr(m_iaddr),
	.mw(mw),
	.mr(mr),
	.rm_idata(rm_idata)
);
 

endmodule
