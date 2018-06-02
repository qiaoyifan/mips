//IDģ��
//��ָ�������
//�õ��������������͡������͡�Դ������1��Դ������2��Ҫд��Ŀ�ļĴ����ĵ�ַ
`include "defines.v"
module id(
    input wire                  rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    //��ȡ��Regfile��ֵ
    input wire[`RegBus]         reg1_data_i,
    input wire[`RegBus]         reg2_data_i,

    //�����Regfile����Ϣ
    output reg                     reg1_read_o,
    output reg                     reg2_read_o,
    output reg[`RegAddrBus]        reg1_addr_o,
    output reg[`RegAddrBus]        reg2_addr_o,

    //�����ִ�н׶�
    output reg[`AluOpBus]          aluop_o,
    output reg[`AluSelBus]         alusel_o,
    output reg[`RegBus]            reg1_o,
    output reg[`RegBus]            reg2_o,
    output reg[`RegAddrBus]        wd_o,
    output reg                     wreg_o
);
//ȡ�õ�ָ���빦����
wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];  //ƫ����
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];

//����ָ��ִ����Ҫ��������
reg[`RegBus]   imm;

//ָʾָ���Ƿ���Ч
reg instvalid;

//��ָ���������
always @ (*) begin
    if(rst == `RstEnable) begin
        aluop_o <=  `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        wd_o    <=  `NOPRegAddr;
        wreg_o  <=  `WriteDisable;
        instvalid   <=  `InstInvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm         <=  32'h0;
    end else begin
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

        case(op)
            `EXE_ORI:   begin   //�ж���ori��ָ����
            //oriָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
            wreg_o  <=  `WriteEnable;
            //��������������߼���������
            aluop_o <=  `EXE_OR_OP;
            //�����������߼�����   
            alusel_o<=  `EXE_RES_LOGIC;
            //��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
            reg1_read_o <= 1'b1;
            //��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
            reg2_read_o <= 1'b0;
            //ָ��ִ����Ҫ��������
            imm <=  {16'h0,inst_i[15:0]};
            //ָ��ִ��Ҫд��Ŀ�ļĴ���
            wd_o <= inst_i[20:16];
            //oriָ����Ч
            instvalid   <=  `InstValid;
            end
			
			`EXE_ANDI:   begin   //�ж���andi��ָ����
            //oriָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
            wreg_o  <=  `WriteEnable;
            //��������������߼����롱����
            aluop_o <=  `EXE_AND_OP;
            //�����������߼�����   
            alusel_o<=  `EXE_RES_LOGIC;
            //��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
            reg1_read_o <= 1'b1;
            //��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
            reg2_read_o <= 1'b0;
            //ָ��ִ����Ҫ��������
            imm <=  {16'h0,inst_i[15:0]};
            //ָ��ִ��Ҫд��Ŀ�ļĴ���
            wd_o <= inst_i[20:16];
            //oriָ����Ч
            instvalid   <=  `InstValid;
            end
			
			`EXE_ADDI:   begin   //�ж���addi��ָ����
            //oriָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
            wreg_o  <=  `WriteEnable;
            //��������������߼���������
            aluop_o <=  `EXE_ADD_OP;
            //�����������߼�����   
            alusel_o<=  `EXE_RES_LOGIC;
            //��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
            reg1_read_o <= 1'b1;
            //��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
            reg2_read_o <= 1'b0;
            //ָ��ִ����Ҫ��������
            imm <=  {16'h0,inst_i[15:0]};
            //ָ��ִ��Ҫд��Ŀ�ļĴ���
            wd_o <= inst_i[20:16];
            //oriָ����Ч
            instvalid   <=  `InstValid;
            end
			
			
			`EXE_XORI:   begin   //�ж���xori��ָ����
            //xoriָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
            wreg_o  <=  `WriteEnable;
            //��������������߼����������
            aluop_o <=  `EXE_XOR_OP;
            //�����������߼�����   
            alusel_o<=  `EXE_RES_LOGIC;
            //��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
            reg1_read_o <= 1'b1;
            //��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
            reg2_read_o <= 1'b0;
            //ָ��ִ����Ҫ��������
            imm <=  {16'h0,inst_i[15:0]};
            //ָ��ִ��Ҫд��Ŀ�ļĴ���
            wd_o <= inst_i[20:16];
            //oriָ����Ч
            instvalid   <=  `InstValid;
            end
			
			6'b000000: begin
			  case(op3)
			    `EXE_ADD_OP:  begin    //�ж���ADDָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼����ӡ�����
				aluop_o <=  `EXE_ADD_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b1;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//addָ����Ч
				instvalid   <=  `InstValid;
				end
				
				`EXE_SUB_OP:  begin    //�ж���subָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼�����������
				aluop_o <=  `EXE_SUB_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b1;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//subָ����Ч
				instvalid   <=  `InstValid;
				end
				
				
				`EXE_AND_OP:  begin    //�ж���ANDָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼����롱����
				aluop_o <=  `EXE_AND_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b1;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//andָ����Ч
				instvalid   <=  `InstValid;
				end
				
				`EXE_OR_OP:  begin    //�ж���ORָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼���������
				aluop_o <=  `EXE_OR_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b1;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//addָ����Ч
				instvalid   <=  `InstValid;
				end
				
				`EXE_XOR_OP:  begin    //�ж���XORָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼����������
				aluop_o <=  `EXE_ADD_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b1;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//addָ����Ч
				instvalid   <=  `InstValid;
				end
				
				`EXE_SLL_OP:  begin    //�ж���SLLָ��
				//addָ����Ҫ�����д��Ŀ�ļĴ����������д���ź�ʹ��
				wreg_o  <=  `WriteEnable;
				//��������������߼����������
				aluop_o <=  `EXE_SLL_OP;
				//�����������߼�����   
				alusel_o<=  `EXE_RES_LOGIC;
				//��Ҫͨ��Regfile�Ķ��˿�1���Ĵ���
				reg1_read_o <= 1'b0;
				//��Ҫͨ��Regfile�Ķ��˿�2���Ĵ���
				reg2_read_o <= 1'b1;
				//ָ��ִ��Ҫд��Ŀ�ļĴ���
				wd_o <= inst_i[15:11];
				//ָ��ִ����Ҫ��ƫ����
                imm <=  {27'h0,inst_i[10:6]};
				//addָ����Ч
				instvalid   <=  `InstValid;
				end
				
			  endcase //case op3
			end
			
            default:begin
            end
        endcase //case op
    end //if
end //always

//ȷ������Դ������1
always @ (*) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if(reg1_read_o == 1'b1) begin
        reg1_o <= reg1_data_i;  //Regfile���˿�1�����ֵ
    end else if(reg1_read_o == 1'b0) begin
        reg1_o <= imm;          //������
    end else begin
        reg1_o <= `ZeroWord;
    end
end

//ȷ������Դ������2
always @ (*) begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if(reg2_read_o == 1'b1) begin
        reg2_o <= reg2_data_i;  //Regfile���˿�1�����ֵ
    end else if(reg2_read_o == 1'b0) begin
        reg2_o <= imm;          //������
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule