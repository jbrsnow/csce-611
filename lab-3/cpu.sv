// da cpu :3
module cpu(input logic clk, input logic rst_n);
	logic [31:0] inst_ram [4095:0];
	initial $readmemh("program.rom", inst_ram); // page 28 microarchitecture.pdf
	
	logic [11:0] PC_FETCH = 12'd0;
	logic [31:0] instruction_EX;
	
	
	// instruction decoder :3
	logic [6:0] funct7;
	logic [4:0] rs2;
	logic [4:0] rs1;
	logic [2:0] funct3;
	logic [4:0] rd;
	logic [6:0] opcode;
	logic [11:0] imm12;
	logic [19:0] imm20;
	
	instruction_decoder ins_d(
		// input
		.instruction_EX(instruction_EX),
		
		// output
		.funct7(funct7),
		.rs2(rs2),
		.rs1(rs1),
		.funct3(funct3),
		.rd(rd),
		.opcode(opcode),
		.imm12(imm12),
		.imm20(imm20)
	);
	
	// extend imm12 to 32 bit
	logic [31:0] imm12_ext = {{20{imm12[11]}}, imm12};
	
	
	// control unit :3
	logic alusrc_EX;
	logic [1:0] regsel_EX;
	logic [3:0] aluop_EX;
	logic regwrite_EX;
	logic GPIO_we;
	
	control_unit ctr_u(
		// input
		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.csr(imm12),
		
		// output
		.alusrc_EX(alusrc_EX),
		.regsel_EX(regsel_EX),
		.aluop_EX(aluop_EX),
		.regwrite_EX(regwrite_EX),
		.GPIO_we(GPIO_we)
	);
	
	
	// reg file :3
	logic [31:0] readdata1;
	logic [31:0] readdata2;
	logic [4:0] regdest_wb;	// pipeline register for writeaddr
	logic regwrite_wb;	// pipeline register for we
	
	regfile reg_f(
		// input
		.clk(clk),
		.we(regwrite_wb),
		.readaddr1(rs1),
		.readaddr2(rs2),
		.writeaddr(regdest_wb),
		.writedata(), // TODO: do this shit
		
		// output
		.readdata1(readdata1),
		.readdata2(readdata2)
	);
	
	// mux for alu B input
	assign alu_mux = alusrc_EX ? imm12_ext : readdata2;
	
	
	// alu :3
	logic [31:0] R;
	
	alu alu_f(
		// input
		.A(readdata1),
		.B(alu_mux),
		.op(aluop_EX),
		
		// output
		.R(R)
	);
	
	// PC :D
	always_ff @(posedge clk) begin
		if (~rst_n) begin
			PC_FETCH <= 12'd0;
			instruction_EX <= 32'd0;
		end else begin
			PC_FETCH <= PC_FETCH + 1'b1;
			instruction_EX <= inst_ram[PC_FETCH];
		end
	end
	
	// pipeLine register for all the R-blocks o_0
	always_ff @(posedge clk) begin
		regdest_wb <= rd
		regwrite_wb <= regwrite_EX;
	end
endmodule
