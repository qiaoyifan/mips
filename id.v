//IDģ��
//��ָ�������
//�õ��������������͡������͡�Դ������1��Դ������2��Ҫд��Ŀ�ļĴ����ĵ�ַ
`include "defines.v"
module id(
    input wire                  rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        instruction,
    input wire                  zero,
	
    //��ȡ��Regfile��ֵ
    input wire[`RegBus]            reg1_data_i,
    input wire[`RegBus]            reg2_data_i,

    //�����Regfile����Ϣ
    output reg                     reg1_read_o,
    output reg                     reg2_read_o,
    output reg[`RegAddrBus]        reg1_addr_o,
    output reg[`RegAddrBus]        reg2_addr_o,

    //�����ִ�н׶�
    output reg [`AluOpBus]         aluop_o,
    output reg[`AluSelBus]         alusel_o,
    output reg[`RegBus]            reg1_o,
    output reg[`RegBus]            reg2_o,
    output reg[`RegAddrBus]        waddr_o,
    output reg                     wreg_o,  //�Ƿ�д�Ĵ���
    output reg[`RegBus]            reg2_oo,
	  //�����PC����
   	output reg                       PCSrc,
	  output reg                     PCWre,
	  output reg[`RegBus]            branch_addr,
	
	  //�����WB����
	  output reg                     ALUM2Reg,
	  output reg                     DataMemRW
	
);
//ȡ�õ�ָ���빦����
//wire[5:0]  op           = instruction[31:26]; //ǰ6λ
wire[4:0]  rs           = instruction[25:21];
wire[5:0]  rt           = instruction[20:16];
wire[4:0]  rd           = instruction[15:11];
wire[15:0] immediate_16 = instruction[15:0];
wire[5:0]  func         = instruction[5:0];	//��6λ
wire [5:0] op           = instruction[31:26];
//ʹ����Ŀ��������op����Ϊrr��ָ��Ĳ������ں���λ����rs��ָ���������ǰ��λ
//wire [5:0] op = (instruction[31:26] !=6'b000000) ? instruction[31:26] : instruction[5:0];

reg i_add,  i_sub,  i_and, i_or, i_xor;
reg i_addi, i_andi,i_ori,i_xori,i_lui;
reg i_sll, i_srl, i_sra;
reg i_sw, i_lw;	
reg i_beq, i_bne, i_j,i_jr, i_jal;
reg i_halt;
//reg i_move;



//ָʾָ���Ƿ���Ч
reg instvalid;

//��ָ���������
always @ (*) begin
    if(rst == `RstEnable) begin
         aluop_o     =  `EXE_NOP_OP;
         alusel_o    = `EXE_RES_NOP;
         waddr_o     =  `NOPRegAddr;
         wreg_o      =  `WriteDisable;
         instvalid   =  `InstInvalid;
         reg1_read_o =  1'b0;
         reg2_read_o =  1'b0;
         reg1_addr_o =  `NOPRegAddr;
         reg2_addr_o =  `NOPRegAddr;
        //imm         <=  32'h0;
    end 
	else begin
	/*
        aluop_o <=  `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o    <=  inst_i[15:11];
        wreg_o  <=  `WriteDisable;
        instvalid   <=  `InstInvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  inst_i[25:21];  //Ĭ�ϵ�һ���������Ĵ���Ϊ�˿�1��ȡ�ļĴ���
        reg2_addr_o <=  inst_i[20:16];  //Ĭ�ϵڶ��������Ĵ���Ϊ�˿�2��ȡ�ļĴ���
        imm         <=  `ZeroWord;    
	*/
	            i_add  = 0;
                i_and  = 0;
                i_sub  = 0;
			    i_or   = 0;
			    i_xor  = 0;
			
		     	i_sll  = 0;
			    i_srl  = 0;
			    i_sra  = 0;
			
			    i_andi = 0;
			    i_addi = 0;
                i_ori  = 0;
                i_xori = 0;
                i_lui  = 0;
            
                //i_move <= 0;
                i_sw   = 0;
                i_lw   = 0;
                i_beq  = 0;
			    i_bne  = 0;
			    i_j    = 0;
			    i_jr   = 0;
			    i_jal  = 0;
			    
			    i_halt = 0;
            //����Ƕ�Ӧ�������򽫶�Ӧ��������Ϊ1

       
        case(op)   
			  `EXE_ORI:  begin i_ori  = 1; aluop_o = `EXE_OR_OP;  end  //
			  `EXE_ADDI: begin i_addi = 1; aluop_o = `EXE_ADD_OP; end
			  `EXE_ANDI: begin i_andi = 1; aluop_o = `EXE_AND_OP; end
			  `EXE_XORI: begin i_xori = 1; aluop_o = `EXE_XOR_OP; end
			  `EXE_LUI:  begin i_lui  = 1; aluop_o = `EXE_ADD_OP; end
			  `EXE_J  :  begin i_j    = 1; branch_addr = {pc_i[31:28],instruction[25:0],2'b00}; end
			  `EXE_JAL:  begin i_jal  = 1; branch_addr = {pc_i[31:28],instruction[25:0],2'b00}; 
			                   aluop_o = `EXE_ADD_OP; end
		  	  `EXE_SW:   begin i_sw    = 1; aluop_o = `EXE_ADD_OP; end
              `EXE_LW:   begin i_lw    = 1; aluop_o = `EXE_ADD_OP; end
			
              `EXE_BEQ:  begin i_beq   = 1; aluop_o = `EXE_SUB_OP; 
                         branch_addr = pc_i + 4'h4 + {immediate_16,2'b00};end
			  `EXE_BNE:  begin i_bne   = 1; aluop_o = `EXE_SUB_OP; 
			                   branch_addr = pc_i + 4'h4 + {immediate_16,2'b00};end
			  
              `EXE_HALT: begin i_halt  = 1;                        end
        
        6'b000000: begin
         case(func)
              
		           `EXE_ADD: begin i_add   = 1; aluop_o = `EXE_ADD_OP; end
               `EXE_AND: begin i_and   = 1; aluop_o = `EXE_AND_OP; end
               `EXE_SUB: begin i_sub   = 1; aluop_o = `EXE_SUB_OP; end
               `EXE_OR:  begin i_or    = 1; aluop_o = `EXE_OR_OP;  end
               `EXE_XOR:  begin i_xor  = 1; aluop_o = `EXE_XOR_OP; end
		    	      `EXE_SLL:  begin i_sll  = 1; aluop_o = `EXE_SLL_OP; end
		           `EXE_SRL:  begin i_srl  = 1; aluop_o = `EXE_SRL_OP; end
			         `EXE_SRA:  begin i_sra  = 1; aluop_o = `EXE_SRA_OP; end
			         `EXE_JR:   begin i_jr   = 1;                        end
			     endcase
         end                 
					          
			//`EXE_MOVE: i_move = 1;
        
      endcase
          reg1_read_o = !(i_sll || i_srl || i_sra || i_jal || i_lui);  //�������������Ҫ����������Ҫreg1data
			    reg2_read_o = (i_add || i_sub || i_and || i_beq || i_bne || i_or || i_xor || i_sll || i_srl || i_sra || i_sw);
			    reg1_addr_o = rs;
			    reg2_addr_o = rt;
			    PCWre = !i_halt;
		      ALUM2Reg  = i_lw;	
			    wreg_o = i_add || i_sub || i_and || i_or || i_xor || i_sll || i_srl || i_sra || i_addi || 
			             i_andi || i_ori || i_xori || i_lw || i_lui || i_jal;  //�Ƿ�д�Ĵ���
			    DataMemRW = i_sw;
			    PCSrc = (i_beq && zero) || i_j || (i_bne && !zero) || i_jal || i_jr; 
			   //Ŀ��Ĵ����������addi,ori,lwָ�дĿ��Ĵ���Ϊrt������Ϊrd
			    waddr_o = (i_addi || i_andi || i_ori || i_sw || i_xori || i_lw) ? rt : rd;
			    waddr_o = (op == `EXE_JAL) ?  5'b11111 : waddr_o;
			    //wreg_o = !(i_j || i_beq || i_bne || i_sw);  // ������Щָ������ָ�Ҫд�Ĵ���
			    instvalid   =  `InstValid; //ָ����Ч
			    alusel_o=  `EXE_RES_LOGIC; //�����������߼����� 
			    branch_addr = (func == `EXE_JR) ? reg1_data_i : branch_addr; //jar_address
    end
end

        
//ȷ������Դ������1
always @ (*) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if(reg1_read_o == 1'b1) begin
        reg1_o <= reg1_data_i;  //Regfile���˿�1�����ֵ
    end else if(reg1_read_o == 1'b0) begin
        if(op == `EXE_JAL)
            reg1_o <= pc_i + 4'h4;
        else if(op == `EXE_LUI)
            reg1_o <= {immediate_16,16'b0000000000000000};
        else
            reg1_o <= immediate_16;          //������
    end else begin
        reg1_o <= `ZeroWord;
    end
end

//ȷ������Դ������2
always @ (*) begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if(reg2_read_o == 1'b1) begin
        if (op == `EXE_SW)
          begin
           reg2_oo <= reg2_data_i;  //Regfile���˿�1�����ֵ
           reg2_o  <= immediate_16;
          end
        else
          reg2_o <= reg2_data_i; 
    end else if(reg2_read_o == 1'b0) begin
        if(op == `EXE_JAL)
           reg2_o <= 0;
        else
           reg2_o <= immediate_16;       //������
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule