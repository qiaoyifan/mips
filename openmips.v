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
//����IDģ���EXģ��
wire[`AluOpBus]   id_aluop;
wire[`AluSelBus]  id_alusel;
wire[`RegBus]     id_reg1;
wire[`RegBus]     id_reg2;
wire[`RegBus]     id_reg22;
wire              id_wreg;
wire[`RegAddrBus] id_waddr;
//����IDģ���Regfileģ��
wire              reg1_read;
wire              reg2_read;
wire[`RegBus]     reg1_data;
wire[`RegBus]     reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;
//����ID��WBģ��
wire              ALUM2Reg;
wire              DataMemRW;

//����ID��PCģ��
wire              PCWre;
wire              PCSrc;
wire[`RegBus]     branch_addr;

//����EXģ���WBģ��
wire              ex_wreg;
wire[`RegAddrBus] ex_waddr;
wire[`RegBus]     ex_wdata;
wire[`RegBus]     ex_reg2;

//����EXģ���IDģ��
wire              zero;

//����WBģ���Regfileģ��
wire[`RegAddrBus] wb_waddr;
wire              wb_wreg;
wire[`RegBus]     wb_wdata;

//����WBģ���MIOCģ��
wire	ior;
wire	iow;
wire	mw;
wire	mr;

wire[`RegBus]     wm_idata;
wire[`RegBus]     m_iaddr;
wire[`RegBus]     rme_idata;
wire[`RegBus] 	   wiodata;
//����MIOC��WB
wire [`RegBus] rm_idata;

//����MIOC��IOģ��

wire[`RegBus] io_addr;
wire io_ce;
wire io_iow;
wire[`RegBus] wdata;
wire[`RegBus] rdata;

//����IO�����
//wire[`RegBus] Button;


//����MIOC��DataMem Ram
wire [3:0] mem_sel;
wire mem_ce;//mem_ce
wire mem_we;//mem_we
wire [`RegBus]	mem_addr;//memaddr_o
wire [`RegBus]	wdata_o;//wrmemdata_o


mioc mioc0(
	//����WB������
	.ior_ctl_i(ior),
	.iow_ctl_i(iow),
	.mw_ctl_i(mw),
	.mr_ctl_i(mr),
	.wm_idata_i(wm_idata),
	.m_iaddr_i(m_iaddr),

	//�͵�WB�����
	.rm_idata(rm_idata),
	
	//����dataMem������
	.rmemdata_i(ram_data_i),
	
	//�͵�mem�����
	.wrmemdata_o(ram_data_o),
    .memaddr_o(ram_addr_o),            
    .memwenb_o(ram_we_o),
    .mem_ce(ram_ce_o),
    .mem_sel_o(ram_sel_o),
			  
	//����IO������
	.wiodata_i(io_data_i),
	
	//�͵�IOģ������		  
	.wiodata(io_data_o),
	.iowenb_o(io_we_o),
    .io_ce(io_ce_o),
    .ioaddr(io_addr_o)
);
//��������
//wire[`RegBus] Seg; //0xFFFFF000
//wire[15:0] Led; //0xFFFFF004
//wire[1:0] Sel; //0xFFFFF008

/*
io io0(
	
	.clk(clk),
    .rst(rst),
	//��MIOC������
    .addr(io_addr),
    .ce(io_ce),
    .iow(iow),
    .wdata(wiodata),
	//�͵�MIOC�����
    .rdata(rdata),
	
	//�͵���������
    //IO devices
    .Seg(Seg), //0xFFFFF000
    .Led(Led), //0xFFFFF004
	//������������
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
    //����Regfileģ�������
    .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),
    //�͵�Regfileģ�����Ϣ
    .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr),
    //�͵�EXģ�����Ϣ
    .aluop_o(id_aluop),   .alusel_o(id_alusel),
    .reg1_o(id_reg1),     .reg2_o(id_reg2),
	.reg2_oo(id_reg22),
    .waddr_o(id_waddr),         .wreg_o(id_wreg),
	//�͵�PCģ����Ϣ
	.PCSrc(PCSrc),    .PCWre(PCWre),
	.branch_addr(branch_addr),
	//�͵�WBģ�����Ϣ
	.ALUM2Reg(ALUM2Reg), .DataMemRW(DataMemRW),
	//����EXģ�����Ϣ
	.zero(zero)
);
//Regfile real
regfile regfile1(
    .clk(clk),
    .rst(rst),
    //��WBģ�鴫����Ϣ
    .we(wb_wreg), .waddr(wb_waddr),
    .wdata(wb_wdata),
    //IDģ�鴫������Ϣ
    .re1(reg1_read),    .raddr1(reg1_addr), 
    .rdata1(reg1_data),
    .re2(reg2_read),    .raddr2(reg2_addr),
    .rdata2(reg2_data)
);
//EX real
ex ex0(
    .rst(rst),
    //��IDģ�鴫������Ϣ
    .aluop_i(id_aluop),   .alusel_i(id_alusel),
    .reg1_i(id_reg1),     .reg2_i(id_reg2),
	.reg2_ii(id_reg22),
    .waddr_i(id_waddr),         .wreg_i(id_wreg),
    //�͵�WBģ�����Ϣ
    .waddr_o(ex_waddr),      .wreg_o(ex_wreg),
    .wdata_o(ex_wdata),   .reg2_o(ex_reg2),
	.zero(zero)
);
//WB real
wb wb0(
    .rst(rst),
	//����EXģ�����Ϣ
    .ex_waddr(ex_waddr),         .ex_wreg(ex_wreg),
    .ex_wdata(ex_wdata),         .reg2_data_i(ex_reg2),
	
    .wb_waddr(wb_waddr),         .wb_wreg(wb_wreg),
    .wb_wdata(wb_wdata),
	//����IDģ�����Ϣ
	.ALUM2Reg(ALUM2Reg),   .DataMemRW(DataMemRW),
	//�͵�MIOCģ�����Ϣ
	.io_r(ior),
	.io_w(iow),
	.wm_idata(wm_idata),
	.m_iaddr(m_iaddr),
	.mw(mw),
	.mr(mr),
	.rm_idata(rm_idata)
);
 

endmodule
