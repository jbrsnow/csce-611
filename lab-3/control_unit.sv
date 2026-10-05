// meow :3
module control_unit(
	input [6:0]	opcode,
	input [2:0]	funct3,
	input [6:0]	funct7,
	input [11:0]	csr,
	output [3:0]	alusrc_EX,
	output [1:0]	regsel_EX,
	output		regwrite_EX,
	output		GPIO_we
);

endmodule
