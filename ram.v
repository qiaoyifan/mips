module ram(
  input wire clk,
  input wire ce,
  input wire we,
  input wire[31:0] addr,
  input wire[31:0] wdata,
  input wire[3:0]  sel,
  output reg[31:0]rdata
  );
  reg [31:0]ram[0:64-1];
  
  always@(negedge clk)
  begin
    if(ce == 1'b0)   
	  rdata<=32'bzzzz_zzzz;
    else
      if(we) rdata     <=  ram[addr];
      else   ram[addr] <=  wdata;
  end
endmodule

