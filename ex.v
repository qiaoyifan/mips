//EXģ��
//��������ģ�鴫�������ݽ�������
`include "defines.v"
module ex(

    input wire          rst,

    //����ģ�鴫������Ϣ
    input wire[`AluOpBus]           aluop_i,
    input wire[`AluSelBus]          alusel_i,
    input wire[`RegBus]             reg1_i,
    input wire[`RegBus]             reg2_i,
    input wire[`RegAddrBus]         wd_i,
    input wire                      wreg_i,

    //������Ϻ�Ľ��
    output reg[`RegAddrBus]         wd_o,
    output reg                      wreg_o,
    output reg[`RegBus]             wdata_o
);

//�����߼�����Ľ�� 
reg[`RegBus] logicout;

//����aluop_iָʾ�����������ͽ�������
always @ (*) begin
    if(rst == `RstEnable) begin
        logicout <= `ZeroWord;
    end else begin
        case(aluop_i)
            `EXE_OR_OP:begin    //���С���"����
                logicout <= reg1_i | reg2_i;
            end
			
			`EXE_ADD_OP:begin    //���С���"����
                logicout <= reg1_i + reg2_i;
            end
			
			`EXE_SUB_OP:begin    //���С���"����
                logicout <= reg1_i - reg2_i;
            end
			
			`EXE_AND_OP:begin    //���С���"����
                logicout <= reg1_i & reg2_i;
            end
			
			`EXE_XOR_OP:begin    //���С����"����
                logicout <= reg1_i ^ reg2_i;
            end
			
			`EXE_SLL_OP:begin    //���С�����"����
			//����ʱӦע�⣬Դ��������reg2,ƫ������reg1
                logicout <= reg2_i << reg1_i[4:0];
            end
			
			`EXE_SRL_OP:begin    //���С�����"����
                logicout <= reg2_i >> reg1_i[4:0];
            end
			
			`EXE_SRA_OP:begin    //���С���������"����
				repeat(reg1_i[4:0])
                     logicout < ={reg2_i[31],reg2_i[31:1]};
			end
			
            default:begin
                logicout<=`ZeroWord;
            end
        endcase
    end //if
end //always

//����alusel_iָʾ���������ͣ�ѡ��һ����������Ϊ���ս��
always @ (*) begin
    wd_o <= wd_i;       //Ҫд��Ŀ�ļĴ�����ַ
    wreg_o <= wreg_i;
    case(alusel_i)
        `EXE_RES_LOGIC:begin
            wdata_o <= logicout;
        end
        default:begin
            wdata_o<=`ZeroWord;
        end
    endcase
end

endmodule
