/**
负责连线，将这几个模块单独拉出来连线是为了在顶层文件中接口方便*/
`include "defines.v"

module openmips_min_sopc(
    input wire clk,
    input wire rst,
	 
	 output wire[15:0] Led,
	 output wire[31:0] Seg,
	 input wire[15:0] Sel,
	 input wire[15:0] Button
	 
);

    wire[`InstBus]     inst;
    wire[`InstAddrBus]    inst_addr;
    wire                  rom_ce;

    wire[`RegBus] ram_data;
    wire[`RegBus] ram_addr_i;
    wire[`RegBus] ram_data_i;
    wire  ram_we_i;
    wire[3:0] ram_sel_i;
    wire  ram_ce_i;
    
    wire[`RegBus] io_data;
    wire[`RegBus] io_addr_i;
    wire[`RegBus] io_data_i;
    wire  io_we_i;
    wire  io_ce_i;
    
    wire rst_sig = rst;
    openmips openmips0(
        .clk(clk),  .rst(rst_sig),
        .rom_addr_o(inst_addr), .rom_data_i(inst),
        .rom_ce_o(rom_ce),
        
        .ram_data_i(ram_data),
        .ram_addr_o(ram_addr_i),
        .ram_data_o(ram_data_i),
        .ram_we_o(ram_we_i),
        .ram_ce_o(ram_ce_i),
        .ram_sel_o(ram_sel_i),
        
        .io_data_i(io_data),
        .io_addr_o(io_addr_i),
        .io_data_o(io_data_i),
        .io_we_o(io_we_i),
        .io_ce_o(io_ce_i)
    );
    
    inst_rom inst_rom0(
		     .ce(rom_ce), 
        .addr(inst_addr),   .inst(inst)
    );

    data_ram data_ram0(
        .clk(clk), .ce(ram_ce_i),
        .we(ram_we_i),  .addr(ram_addr_i),
        .sell(ram_sel_i),  .data_i(ram_data_i),
        .data_o(ram_data)
    );
    
    io io0(
      .clk(clk),  .rst(rst_sig),
		  .addr(io_addr_i), .ce(io_ce_i), .iow(io_we_i),  
      .rdata(io_data),  .wdata(io_data_i),
		  
		  .Led(Led),
		  .Sel(Sel),
		  .Seg(Seg),
		  .Button(Button)
    );
  
endmodule
