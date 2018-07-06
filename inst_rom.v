`include "defines.v"
module inst_rom(
    input wire          ce,
    input wire[`InstAddrBus]    addr,
    output reg[`InstBus]        inst
);

reg[`InstBus] inst_mem[0:`InstMemNum-1];

initial //$readmemh ("inst_rom.data",inst_mem);
  begin
     
	 /*��ˮ��ÿ�ν����жϿ��������Ƿ�ı䣬����ı���������ˮ�����������ǰ��ˮ
	   ,������ǰ��������ÿ��λ��ʾ��һ��������ϣ����ڹ���16�����أ�����8������ܣ�
	   �˴��ҽ�����ܷ�Ϊ���飬�����������ʾ��������һ����*/
	  inst_mem[0] = 32'h34210001;//ǰ����ָ��Ϊ�˺���������չ��ʱ����
	  inst_mem[1] = 32'h34210001;
	  inst_mem[2] = 32'h34220002;
	  inst_mem[3] = 32'h3484ffff;  //ORIָ�4�żĴ���|0x0000ffff
	  inst_mem[4] = 32'h00042c00;  //����ָ�4�żĴ���������16λ�浽5�żĴ���
	  inst_mem[5] = 32'h8ca6f008;   //�ѿ��ص�������6�żĴ���
	  inst_mem[6] = 32'h20c70000;   //��6�żĴ������͵�7�żĴ������ں���Ƚ�   
	  inst_mem[7] = 32'haca7f000;   //��7�żĴ���������ʾ�������
	  inst_mem[8] = 32'haca6f004;   //�����żĴ������͵�LED
	  //inst_mem[9] = 32'h00063040;	// �����żĴ���������һλ��6�żĴ��� 
	  inst_mem[9] = 32'h00064840;	// �����żĴ���������һλ��9�żĴ��� 
	  //0000-00 00-000 0-0110 0100-1 000-01 00-00s00  00064840
	  //0010-00 01-001 0-0110 0000 0000 0000 0000	21260000
	  inst_mem[10] = 32'h21260000;//9�żĴ��� �ͻ�6�żĴ���;//9�żĴ��� �ͻ�6�żĴ���
	  inst_mem[11] = 32'h8ca8f008;   //�ѿ��ص�������8�żĴ���
	  //1000-11 00-101 0-1000 
	  inst_mem[12] = 32'h11070001;   //�Ƚ�8�żĴ�����7�żĴ�������ȼ���ת,ִ�е�14��ָ��
	  //0001-00 01-000 0-0111- 0000 0000 0000 0001
	  inst_mem[13] = 32'h15070001;   //�Ƚ�8�żĴ�����7�żĴ��������ȼ���ת,ִ�е�15��ָ��
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