`define RstEnable 1'b1          //复位使能
`define RstDisable 1'b0         //复位除能
`define WriteEnable 1'b1        //写使能
`define WriteDisable 1'b0       //写除能
`define ReadEnable 1'b1         //读使能
`define ReadDisable 1'b0        //读除能
`define InstValid 1'b0          //指令有效
`define InstInvalid 1'b1        //指令无效
`define ChipEnable 1'b1         //芯片使能
`define ChipDisable 1'b0        //芯片禁止
`define ZeroWord 32'h00000000   //32位数字0
`define AluOpBus 5:0            //译码阶段输出操作子类型数据宽度
`define AluSelBus 2:0           //译码阶段输出操作类型数据宽度
`define EXE_ORI   6'b001101      //指令ori的指令码
`define EXE_ADDI  6'b001000      //指令addi的指令码
`define EXE_ANDI  6'b001100      //指令andi的指令码
`define EXE_XORI  6'b001110      //指令xori的指令码
`define EXE_LUI   6'b001111
`define EXE_BEQ   6'b000100       //指令beq的指令码
`define EXE_BNE   6'b000101       //指令bne的指令码
`define EXE_J     6'b000010       //指令j的指令码
`define EXE_JR    6'b001000
`define EXE_JAL   6'b000011
`define EXE_ADD   6'b100000       //指令add的指令码
`define EXE_SUB   6'b100010       //指令sub的指令码
`define EXE_AND   6'b100100       //指令and的指令码
`define EXE_OR    6'b100101
`define EXE_XOR   6'b100110       //指令xor的指令码
`define EXE_SLL   6'b000000       //指令sll的指令码
`define EXE_SRL   6'b000010       //指令srl的指令码
`define EXE_SRA   6'b000011       //指令sra的指令码
`define EXE_LW    6'b100011       //指令lw的指令码
`define EXE_SW    6'b101011       //指令sw的指令码
`define EXE_HALT  6'b111111
//

//AluOp
`define EXE_OR_OP  6'b100101
`define EXE_NOP_OP 6'b000000     // error
`define EXE_ADD_OP 6'b100000
`define EXE_SUB_OP 6'b100010
`define EXE_AND_OP 6'b100100  //寄存器与
`define EXE_XOR_OP 6'b100110  //寄存器异或
`define EXE_SLL_OP 6'b000000  //左移
`define EXE_SRL_OP 6'b000010  //逻辑左移
`define EXE_SRA_OP 6'b000011  //算数右移
//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP 3'b000

`define InstAddrBus 31:0        //ROM的地址总线宽度
`define InstBus 31:0            //ROM的数据总线宽度
`define InstMemNumLog2 17       //ROM地址线宽度 2^17=131072
`define InstMemNum 131071       //ROM的实际大小128KB

`define RegAddrBus 4:0          //Regfile模块的地址线宽度
`define RegBus 31:0             //Regfile模块的数据线宽度
`define NOPRegAddr 5'b00000     //空操作使用的寄存器地址
`define RegNum 32               //通用寄存器的数量
`define RegNumLog2 5            //寻址通用寄存器使用的地址位数

`define DataAddrBus         31:0
`define DataBus             31:0
`define ByteWidth           7:0
`define DataMemNum          511
`define DataMemNumLog2      10


`define SEG 32'hFFFFF000
`define LED	32'hFFFFF004
`define	KEY	32'hFFFFF008
`define	BUTTON	32'hFFFFF012


