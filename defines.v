`define RstEnable 1'b1          //��λʹ��
`define RstDisable 1'b0         //��λ����
`define WriteEnable 1'b1        //дʹ��
`define WriteDisable 1'b0       //д����
`define ReadEnable 1'b1         //��ʹ��
`define ReadDisable 1'b0        //������
`define InstValid 1'b0          //ָ����Ч
`define InstInvalid 1'b1        //ָ����Ч
//
`define JumpEnable 1'b1         //��תʹ��
`define JumpDisable 1'b0        //��ת����
//
`define ChipEnable 1'b1         //оƬʹ��
`define ChipDisable 1'b0        //оƬ��ֹ
`define ZeroWord 32'h00000000   //32λ����0
`define AluOpBus 7:0            //����׶�����������������ݿ��
`define AluSelBus 2:0           //����׶���������������ݿ��
`define EXE_ORI   6'b001101     //ָ��ori��ָ����
`define EXE_ADDI  6'b001000     //ָ��andi��ָ����
`define EXE_ANDI  6'b001100     //ָ��addi��ָ����
`define EXE_XORI  6'b001110     //ָ��xori��ָ����
`define EXE_LW    6'b100011     //ָ��lw��ָ����
`define EXE_SW    6'b101011     //ָ��sw��ָ����
`define EXE_BEQ   6'b000100     //ָ��beq��ָ����
`define EXE_BNE   6'b000101     //ָ��bne��ָ����
`define EXE_LUI   6'b001111     //ָ��lui��ָ����
`define EXE_J     6'b000010     //ָ��j��ָ����
`define EXE_JAL   6'b000011     //ָ��jal��ָ����

//AluOp
`define EXE_OR_OP 6'b100101
//`define EXE_ORI_OP 8'b01011010
`define EXE_NOP_OP 6'b000000
`define EXE_ADD_OP 6'b100000
`define EXE_AND_OP 6'b100100
`define EXE_SUB_OP 6'b100010
`define EXE_XOR_OP 6'b100110
`define EXE_SLL_OP 6'b000000
`define EXE_SRL_OP 6'b000010
`define EXE_SRA_OP 6'b000011
`define EXE_JR_OP  6'b001000

//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP 3'b000

`define InstAddrBus 31:0        //ROM�ĵ�ַ���߿��
`define InstBus 31:0            //ROM���������߿��
`define InstMemNumLog2 17       //ROM��ַ�߿�� 2^17=131072
`define InstMemNum 131071       //ROM��ʵ�ʴ�С128KB

`define RegAddrBus 4:0          //Regfileģ��ĵ�ַ�߿��
`define RegBus 31:0             //Regfileģ��������߿��
`define NOPRegAddr 5'b00000     //�ղ���ʹ�õļĴ�����ַ
`define RegNum 32               //ͨ�üĴ���������
`define RegNumLog2 5            //Ѱַͨ�üĴ���ʹ�õĵ�ַλ��