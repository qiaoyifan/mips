`timescale 1ns / 1ps

 module clk_div(input clk,
					input rst,
					//input SW2,
					output reg[31:0]clkdiv
					//output Clk_CPU
					);
					
// Clock divider-ʱ�ӷ�Ƶ��


	always @ (posedge clk or posedge rst) begin 
		if (rst) clkdiv <= 0; else clkdiv <= clkdiv + 1'b1; end
		
	//assign Clk_CPU = (SW2)? clkdiv[26] : clkdiv[0];
		
endmodule
