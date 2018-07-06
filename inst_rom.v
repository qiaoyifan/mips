`include "defines.v"
module inst_rom(
    input wire          ce,
    input wire[`InstAddrBus]    addr,
    output reg[`InstBus]        inst
);

reg[`InstBus] inst_mem[0:`InstMemNum-1];

initial //$readmemh ("inst_rom.data",inst_mem);
  begin
     
	 /*流水灯每次进行判断开关数据是否改变，如果改变则重新流水，否则继续当前流水
	   ,并将当前开关数据每四位显示到一个数码管上，由于共有16个开关，但有8个数码管，
	   此处我将数码管分为两组，两组数码管显示的数据是一样的*/
	  inst_mem[0] = 32'h34210001;//前三条指令为了后续程序扩展暂时留用
	  inst_mem[1] = 32'h34210001;
	  inst_mem[2] = 32'h34220002;
	  inst_mem[3] = 32'h3484ffff;  //ORI指令，4号寄存器|0x0000ffff
	  inst_mem[4] = 32'h00042c00;  //左移指令，4号寄存器数左移16位存到5号寄存器
	  inst_mem[5] = 32'h8ca6f008;   //把开关的数读到6号寄存器
	  inst_mem[6] = 32'h20c70000;   //把6号寄存器数送到7号寄存器便于后面比较   
	  inst_mem[7] = 32'haca7f000;   //把7号寄存器的数显示到数码管
	  inst_mem[8] = 32'haca6f004;   //把六号寄存器数送到LED
	  //inst_mem[9] = 32'h00063040;	// 把六号寄存器数左移一位给6号寄存器 
	  inst_mem[9] = 32'h00064840;	// 把六号寄存器数左移一位给9号寄存器 
	  //0000-00 00-000 0-0110 0100-1 000-01 00-00s00  00064840
	  //0010-00 01-001 0-0110 0000 0000 0000 0000	21260000
	  inst_mem[10] = 32'h21260000;//9号寄存器 送回6号寄存器;//9号寄存器 送回6号寄存器
	  inst_mem[11] = 32'h8ca8f008;   //把开关的数读到8号寄存器
	  //1000-11 00-101 0-1000 
	  inst_mem[12] = 32'h11070001;   //比较8号寄存器和7号寄存器，相等即跳转,执行第14条指令
	  //0001-00 01-000 0-0111- 0000 0000 0000 0001
	  inst_mem[13] = 32'h15070001;   //比较8号寄存器和7号寄存器，不等即跳转,执行第15条指令
	  //000101 0
	  inst_mem[14] = 32'h08000007;
	  //
	  inst_mem[15] = 32'h08000005;
	  
	  
	 /*
	 //
	  inst_mem[0] = 32'h34210001;
	  inst_mem[1] = 32'h34210001;
	  inst_mem[2] = 32'h34220002;
	  inst_mem[3] = 32'h3484ffff;
	  inst_mem[4] = 32'h00042c00;
	  inst_mem[5] = 32'h8ca6f008;
	  
	  inst_mem[7] = 32'h00063840;	//  
	  inst_mem[8] = 32'haca6f004;
	  inst_mem[9] = 32'h20e60000;
	  inst_mem[10] = 32'h08000007;
	 */
	  /*
	  //
	  inst_mem[0] = 32'h34210001;
	  inst_mem[1] = 32'h34210001;
	  inst_mem[2] = 32'h34220002;
	  inst_mem[3] = 32'h3484ffff;
	  inst_mem[4] = 32'h00042c00;
	  inst_mem[5] = 32'h8ca6f008;
	  inst_mem[6] = 32'haca6f004;
	  inst_mem[7] = 32'h08000005;
	  */
	  
  end
always @ (*) begin
    if(ce == `ChipDisable) begin
        inst <= `ZeroWord;
    end else begin
        inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
    end
end

endmodule