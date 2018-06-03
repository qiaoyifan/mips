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
    output wire                 rom_ce_o
);
//连接ID模块和EX模块
wire[`AluOpBus] id_aluop;
wire[`AluSelBus] id_alusel;
wire[`RegBus] id_reg1;
wire[`RegBus] id_reg2;
wire          id_wreg;
wire[`RegAddrBus] id_wd;
//连接ID模块和Regfile模块
wire reg1_read;
wire reg2_read;
wire[`RegBus] reg1_data;
wire[`RegBus] reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;
//连接EX模块和WB模块
wire ex_wreg;
wire[`RegAddrBus] ex_wd;
wire[`RegBus] ex_wdata;
//连接WB模块和Regfile模块
wire[`RegAddrBus] wb_wd;
wire wb_wreg;
wire[`RegBus] wb_wdata;

//连接ID模块和PC模块
wire branch_flag;
wire [`InstAddrBus]  branch_addr;
//pc_reg real
pc_reg pc_reg0(
    .clk(clk),  .rst(rst),  .pc(rom_addr_o),    .ce(rom_ce_o),
	//来自ID模块的输入
	.branch_addr(branch_addr),  .branch_flag(branch_flag)
);
//ID real
id id0(
    .rst(rst),  
    .pc_i(rom_addr_o), 
    .inst_i(rom_data_i),
    //来自Regfile模块的输入
    .reg1_data_i(reg1_data),    .reg2_data_i(reg2_data),
    //送到Regfile模块的信息
    .reg1_read_o(reg1_read),    .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),    .reg2_addr_o(reg2_addr),
    //送到EX模块的信息
    .aluop_o(id_aluop),   .alusel_o(id_alusel),
    .reg1_o(id_reg1),     .reg2_o(id_reg2),
    .wd_o(id_wd),         .wreg_o(id_wreg)
);
//Regfile real
regfile regfile1(
    .clk(clk),
    .rst(rst),
    //从WB模块传来信息
    .we(wb_wreg), .waddr(wb_wd),
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
    .wd_i(id_wd),         .wreg_i(id_wreg),
    //送到WB模块的信息
    .wd_o(ex_wd),         .wreg_o(ex_wreg),
    .wdata_o(ex_wdata)
);
//WB real
wb wb0(
    .rst(rst),
    .ex_wd(ex_wd),         .ex_wreg(ex_wreg),
    .ex_wdata(ex_wdata),
    .wb_wd(wb_wd),  .wb_wreg(wb_wreg),
    .wb_wdata(wb_wdata)
);
        
endmodule
