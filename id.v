//ID模块
//对指令进译码
//得到并输出运算的类型、子类型、源操作数1、源操作数2、要写入目的寄存器的地址
`include "defines.v"
module id(
    input wire                  rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    //读取得Regfile的值
    input wire[`RegBus]         reg1_data_i,
    input wire[`RegBus]         reg2_data_i,

    //输出到Regfile的信息
    output reg                     reg1_read_o,
    output reg                     reg2_read_o,
    output reg[`RegAddrBus]        reg1_addr_o,
    output reg[`RegAddrBus]        reg2_addr_o,

    //输出到执行阶段
    output reg[`AluOpBus]          aluop_o,
    output reg[`AluSelBus]         alusel_o,
    output reg[`RegBus]            reg1_o,
    output reg[`RegBus]            reg2_o,
    output reg[`RegAddrBus]        wd_o,
    output reg                     wreg_o,
	
	//输出到PC阶段，用来实现J型指令
	output reg [`InstAddrBus]     branch_addr,
	//跳转使能
	output reg                    branch_flag
);
//取得的指令码功能码
wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];  //偏移量
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];

//保存指令执行需要的立即数
reg[`RegBus]   imm;

//指示指令是否有效
reg instvalid;

//对指令进行译码
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
        reg1_addr_o <=  inst_i[25:21];  //默认第一个操作数寄存器为端口1读取的寄存器
        reg2_addr_o <=  inst_i[20:16];  //默认第二个操作寄存器为端口2读取的寄存器
        imm         <=  `ZeroWord;    

        case(op)
            `EXE_ORI:   begin   //判断是ori的指令码
            //ori指令需要将结果写入目的寄存器，则输出写入信号使能
            wreg_o  <=  `WriteEnable;
            //运算的子类型是逻辑“或”运算
            aluop_o <=  `EXE_OR_OP;
            //运算类型是逻辑运算   
            alusel_o<=  `EXE_RES_LOGIC;
            //需要通过Regfile的读端口1读寄存器
            reg1_read_o <= 1'b1;
            //需要通过Regfile的读端口2读寄存器
            reg2_read_o <= 1'b0;
            //指令执行需要的立即数
            imm <=  {16'h0,inst_i[15:0]};
            //指令执行要写的目的寄存器
            wd_o <= inst_i[20:16];
            //ori指令有效
            instvalid   <=  `InstValid;
            end
			
			`EXE_ANDI:   begin   //判断是andi的指令码
            //ori指令需要将结果写入目的寄存器，则输出写入信号使能
            wreg_o  <=  `WriteEnable;
            //运算的子类型是逻辑“与”运算
            aluop_o <=  `EXE_AND_OP;
            //运算类型是逻辑运算   
            alusel_o<=  `EXE_RES_LOGIC;
            //需要通过Regfile的读端口1读寄存器
            reg1_read_o <= 1'b1;
            //需要通过Regfile的读端口2读寄存器
            reg2_read_o <= 1'b0;
            //指令执行需要的立即数
            imm <=  {16'h0,inst_i[15:0]};
            //指令执行要写的目的寄存器
            wd_o <= inst_i[20:16];
            //ori指令有效
            instvalid   <=  `InstValid;
            end
			
			`EXE_ADDI:   begin   //判断是addi的指令码
            //ori指令需要将结果写入目的寄存器，则输出写入信号使能
            wreg_o  <=  `WriteEnable;
            //运算的子类型是逻辑“或”运算
            aluop_o <=  `EXE_ADD_OP;
            //运算类型是逻辑运算   
            alusel_o<=  `EXE_RES_LOGIC;
            //需要通过Regfile的读端口1读寄存器
            reg1_read_o <= 1'b1;
            //需要通过Regfile的读端口2读寄存器
            reg2_read_o <= 1'b0;
            //指令执行需要的立即数
            imm <=  {16'h0,inst_i[15:0]};
            //指令执行要写的目的寄存器
            wd_o <= inst_i[20:16];
            //ori指令有效
            instvalid   <=  `InstValid;
            end
			
			
			`EXE_XORI:   begin   //判断是xori的指令码
            //xori指令需要将结果写入目的寄存器，则输出写入信号使能
            wreg_o  <=  `WriteEnable;
            //运算的子类型是逻辑“异或”运算
            aluop_o <=  `EXE_XOR_OP;
            //运算类型是逻辑运算   
            alusel_o<=  `EXE_RES_LOGIC;
            //需要通过Regfile的读端口1读寄存器
            reg1_read_o <= 1'b1;
            //需要通过Regfile的读端口2读寄存器
            reg2_read_o <= 1'b0;
            //指令执行需要的立即数
            imm <=  {16'h0,inst_i[15:0]};
            //指令执行要写的目的寄存器
            wd_o <= inst_i[20:16];
            //ori指令有效
            instvalid   <=  `InstValid;
            end
			
			`EXE_LUI:   begin   //判断是lui的指令码
            //lui指令需要将结果写入目的寄存器，则输出写入信号使能
            wreg_o  <=  `WriteEnable;
            //运算的子类型是逻辑“左移”运算
            aluop_o <=  `EXE_OR_OP;
            //运算类型是逻辑运算   
            alusel_o<=  `EXE_RES_LOGIC;
            //需要通过Regfile的读端口1读寄存器
            reg1_read_o <= 1'b0;
            //需要通过Regfile的读端口2读寄存器
            reg2_read_o <= 1'b1;
            //指令执行需要的立即数
			//在此直接使用拼接操作，然后与rt或，避免移位操作
            imm <=  {inst_i[15:0],16'h0};
            //指令执行要写的目的寄存器
            wd_o <= inst_i[20:16];
            //lui指令有效
            instvalid   <=  `InstValid;
            end
			
			
			`EXE_BEQ:   begin   //判断是beq的指令码
            //beq指令需要将结果写入pc，则branch_flag信号使能
            branch_flag  <=  `JumpEnable;
            //此处不需要ALU进行操作
            //运算类型是逻辑运算   
			//alusel_o<=  `EXE_RES_LOGIC;
            if(reg1_data_i == reg2_data_i)
				branch_addr <= pc_i + {14'b0, inst_i[15:0],2'b0};
            //ori指令有效
            //instvalid   <=  `InstValid;
            end
			
			`EXE_BNE:   begin   //判断是bne的指令码
            //beq指令需要将结果写入pc，则branch_flag信号使能
            branch_flag  <=  `JumpEnable;
            //此处不需要ALU进行操作
            //运算类型是逻辑运算   
			//alusel_o<=  `EXE_RES_LOGIC;
            if(reg1_data_i != reg2_data_i)
				branch_addr <= pc_i + {14'b0, inst_i[15:0],2'b0};
            //ori指令有效
            //instvalid   <=  `InstValid;
            end
			
			`EXE_J:   begin   //判断是j的指令码
            //beq指令需要将结果写入pc，则branch_flag信号使能
            branch_flag  <=  `JumpEnable;
            //此处不需要ALU进行操作
            //运算类型是逻辑运算   
			//alusel_o<=  `EXE_RES_LOGIC;
            /*
			 Actually, j doesn't quite manage a 32-bit address: 
			 The top 4 address bits of the target are not defined 
			 by the instruction, and thetop 4 bits of the current 
			 PC value are used instead. Most of the time this 
			 doesn't matter; 28 bits still gives a maximum code size of 256 MB.
			*/
			//最后两位为0，中间26为是address，前四位用当前PC值填充
			branch_addr <= {pc_i[31:28], inst_i[25:0],2'b00};
            end
			
			
			6'b000000: begin
			  case(op3)
			    `EXE_ADD_OP:  begin    //判断是ADD指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“加”运算
				aluop_o <=  `EXE_ADD_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b1;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//add指令有效
				instvalid   <=  `InstValid;
				end
				
				`EXE_SUB_OP:  begin    //判断是sub指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“减”运算
				aluop_o <=  `EXE_SUB_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b1;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//sub指令有效
				instvalid   <=  `InstValid;
				end
				
				
				`EXE_AND_OP:  begin    //判断是AND指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“与”运算
				aluop_o <=  `EXE_AND_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b1;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//and指令有效
				instvalid   <=  `InstValid;
				end
				
				`EXE_OR_OP:  begin    //判断是OR指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“或”运算
				aluop_o <=  `EXE_OR_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b1;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//add指令有效
				instvalid   <=  `InstValid;
				end
				
				`EXE_XOR_OP:  begin    //判断是XOR指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“异或”运算
				aluop_o <=  `EXE_ADD_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b1;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//add指令有效
				instvalid   <=  `InstValid;
				end
				
				`EXE_SLL_OP:  begin    //判断是SLL指令
				//add指令需要将结果写入目的寄存器，则输出写入信号使能
				wreg_o  <=  `WriteEnable;
				//运算的子类型是逻辑“异或”运算
				aluop_o <=  `EXE_SLL_OP;
				//运算类型是逻辑运算   
				alusel_o<=  `EXE_RES_LOGIC;
				//需要通过Regfile的读端口1读寄存器
				reg1_read_o <= 1'b0;
				//需要通过Regfile的读端口2读寄存器
				reg2_read_o <= 1'b1;
				//指令执行要写的目的寄存器
				wd_o <= inst_i[15:11];
				//指令执行需要的偏移量
                imm <=  {27'h0,inst_i[10:6]};
				//add指令有效
				instvalid   <=  `InstValid;
				end
				
				
			  endcase //case op3
			end
			
            default:begin
            end
        endcase //case op
    end //if
end //always

//确定运算源操作数1
always @ (*) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if(reg1_read_o == 1'b1) begin
        reg1_o <= reg1_data_i;  //Regfile读端口1的输出值
    end else if(reg1_read_o == 1'b0) begin
        reg1_o <= imm;          //立即数
    end else begin
        reg1_o <= `ZeroWord;
    end
end

//确定运算源操作数2
always @ (*) begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if(reg2_read_o == 1'b1) begin
        reg2_o <= reg2_data_i;  //Regfile读端口1的输出值
    end else if(reg2_read_o == 1'b0) begin
        reg2_o <= imm;          //立即数
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule