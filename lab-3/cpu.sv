// da cpu :3
module cpu(input logic clk, input logic rst_n);
	logic [31:0] inst_ram [4095:0];
	initial $readmemh("program.rom",inst_ram);
	
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
	
	// reg file :3
	logic [31:0] readdata1;
	logic [31:0] readdata2;
	
	regfile reg_f(
		// input
		.clk(clk),
		.we(), // TODO: do this shit
		.readaddr1(rs1),
		.readaddr2(rs2),
		.writeaddr(rd),
		.writedata(), // TODO: do this shit
		
		// output
		.readdata1(readdata1),
		.readdata2(readdata2)
	);
	
	always_ff @(posedge clk) begin
		if (~rst_n) begin
			PC_FETCH <= 12'd0;
			instruction_EX <= 32'd0;
		end else begin
			PC_FETCH <= PC_FETCH + 1'b1;
			instruction_EX <= inst_ram[PC_FETCH];
		end
	end
	always_ff @(posedge clk) begin //PipeLine register for all the R-blocks o_0
		<signal_name>_wb <= <signal_name>_EX;
		end;
endmodule
