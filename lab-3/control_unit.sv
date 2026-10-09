// meow :3
module control_unit(
	input [6:0]	opcode,
	input [2:0]	funct3,
	input [6:0]	funct7,
	input [11:0]	csr,
	output 		alusrc_EX,
	output [1:0]	regsel_EX,
	output [3:0]	aluop_EX,
	output		regwrite_EX,
	output		GPIO_we
	
);

always_comb begin
	// default values
	alusrc_EX  = 1'b0;
	regsel_EX  = 2'b00;
	regwrite_EX = 1'b0;
	GPIO_we    = 1'b0;
	aluop_EX = 4'b0000;
	
	// r-type instructions
	if (opcode == 7'b01100110) begin 
		regsel_EX = 2'b10;
		regwrite_EX = 1'b1;
		GPIO_we = 1'b0;
		alusrc_EX = 1'b0;
	
		if (funct3 == 3'b000) begin
			if (funct7 == 7'b0000000) begin
				aluop_EX = 4'b0011; // +
			end
			else if (funct7 == 7'b0000000) begin
				aluop_EX = 4'b0100; // -
			end
			else if (funct7 == 7'b0000000) begin
				aluop_EX = 4'b0101; // *
			end
			else begin
				regwrite_EX = 1'b0;
			end
		end
		else if (funct3 == 3'b010) begin 
			aluop_EX = 4'b1100;  // SLT
		end
		else if (funct3 == 3'b111) begin
			aluop_EX = 4'b0000;
		end
		else if (funct3 == 3'b111) begin
			aluop_EX = 4'b1000;
		end
		else begin
			regwrite_EX = 1'b0;
		end
	end

	if (opcode == 7'b0001101) begin
		regsel_EX = 2'b10;
		regwrite_EX = 1'b1;
		GPIO_we = 1'b0;
		alusrc_EX = 1'b1;
		if (funct3 == 3'b001) begin 
			aluop_EX = 4'b1000; // andi
		end
		else if (funct3 == 3'b011) begin
			aluop_EX = 4'b1000; // slli
		end
		else begin
			regwrite_EX = 1'b0;
		end
	end

	if (opcode == 7'h73) begin
		if (csr == 12'hf02) begin // csrrw_HEX
			regwrite_EX = 1'b0;
			GPIO_we = 1'b1;       
		end
		else if (csr == 12'hf00) begin // csrrw_SW
			regsel_EX = 2'b00;
			regwrite_EX = 1'b1;
			GPIO_we = 1'b0;
		end
		else begin
			regwrite_EX = 1'b0;
		end
	end

	if (opcode == 7'h37) begin // lui
		regsel_EX = 2'b01;
		regwrite_EX = 1'b1;
		GPIO_we = 1'b0;
	end
	else begin
		regwrite_EX = 1'b0;
	end
end
	
endmodule
