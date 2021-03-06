//EX模块
//根据译码模块传来的数据进行运算
`include "defines.v"
module ex(

    input wire                      rst,

    //译码模块传来的信息
    input wire[`AluOpBus]           aluop_i,
    input wire[`AluSelBus]          alusel_i,
    input wire[`RegBus]             reg1_i,
    input wire[`RegBus]             reg2_i,
    input wire[`RegAddrBus]         waddr_i,
    input wire                      wreg_i,
    input wire[`RegBus]             reg2_ii,

    //运算完毕后的结果
    output reg[`RegAddrBus]         	waddr_o,
    output reg                       	wreg_o,
    output reg[`RegBus]             	wdata_o,
	  output reg[`RegBus]            	reg2_o,
	  //送到id
	  output wire                     zero
);

//保存逻辑运算的结果 
reg[`RegBus] logicout;
//reg [4:0]   num; 
//根据aluop_i指示的运算子类型进行运算
always @ (*) begin
    if(rst == `RstEnable) begin
        logicout = `ZeroWord;
    end else begin
        case(aluop_i)
      `EXE_OR_OP:begin    //进行“或"运算
                logicout = reg1_i | reg2_i;
            end
			
			`EXE_ADD_OP:begin    //进行“加"运算
                logicout = reg1_i + reg2_i;
            end
			
			`EXE_SUB_OP:begin    //进行“减"运算
                logicout = reg1_i - reg2_i;
            end
			
			`EXE_AND_OP:begin    //进行“与"运算
                logicout = reg1_i & reg2_i;
            end
			
			`EXE_XOR_OP:begin    //进行“异或"运算
                logicout = reg1_i ^ reg2_i;
            end
			
			`EXE_SLL_OP:begin    //进行“左移"运算
			//左移时应注意，源操作数在reg2,偏移量在reg1
                logicout = reg2_i << reg1_i[10:6];
            end
			
			`EXE_SRL_OP:begin    //进行“右移"运算
                logicout = reg2_i >> reg1_i[10:6];
            end
			
			`EXE_SRA_OP:begin    //进行“算数右移"运算
			    //num = reg1_i[4:0];
				repeat(5) //由于我所用的开发板原因，将此处改为一个常数，此处待更改
                     logicout ={reg2_i[31],reg2_i[31:1]};
			end
			
            default:begin
                logicout =`ZeroWord;
            end
        endcase
    end 
	//零标志位，为了bne和beq指令
end //always

//根据alusel_i指示的运算类型，选择一个运算结果作为最终结果
always @ (*) begin
    waddr_o = waddr_i;       //要写的目的寄存器地址
    wreg_o  = wreg_i;
    reg2_o  = reg2_ii;
    case(alusel_i)
        `EXE_RES_LOGIC:begin
            wdata_o = logicout;
        end
        default:begin
            wdata_o =`ZeroWord;
        end
    endcase
end
assign zero = (logicout == 0) ? 1 : 0;  //运算0标志位
endmodule
