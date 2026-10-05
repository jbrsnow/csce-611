// decoder :3
module instruction_decoder(
	input [31:0] 	instruction_EX,
	output [6:0]	funct7,
	output [4:0]	rs2,
	output [4:0]	rs1,
	output [2:0]	funct3,
	output [4:0]	rd,
	output [6:0]	opcode,
	output [11:0]	imm12,
	output [19:0]	imm20
);
	assign funct7 = instruction_EX[31:25];	// used in R-type
	assign rs2 = 	instruction_EX[24:20];	// used in R-type
	assign rs1 = 	instruction_EX[19:15];	// used in R,I-type
	assign funct3 = instruction_EX[14:12];	// used in R,I-type
	assign rd = 	instruction_EX[11:7];	// used in R,I,D-type
	assign opcode = instruction_EX[6:0];	// used in R,I,D-type
	
	assign imm12 = 	instruction_EX[31:20];	// used in I-type
	assign imm20 = 	instruction_EX[31:12]	// used in U-type
	
endmodule
