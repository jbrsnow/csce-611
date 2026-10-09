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
	// most assigments to _EX is lowk redundant but we ball
	aluop_EX = 4'b0000;
	alusrc_EX  = 1'b0;
	regsel_EX  = 2'b00;
	regwrite_EX = 1'b0;
	GPIO_we    = 1'b0;
	
	// r-type instruction
	if (opcode == 7'h33) begin
		alusrc_EX  = 1'b0;
		regsel_EX = 2'b10;
		regwrite_EX = 1'b1;
		GPIO_we    = 1'b0;

		if (funct3 == 3'b000) begin
			if (funct7 == 7'h0) begin	// add
				aluop_EX = 4'b0011;
			end
			
			else if (funct7 == 7'h20) begin	// sub
				aluop_EX = 4'b0100;
			end
			
			else if (funct7 == 7'h1) begin	// mul
				aluop_EX = 4'b0101;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		
		else if (funct3 == 3'b010) begin
			if (funct7 == 7'h0) begin	// slt
				aluop_EX = 4'b1100;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		

		else if (funct3 == 3'b111) begin
			if (funct7 == 7'h0) begin	// and
				aluop_EX = 4'b000;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end

		else if (funct3 == 3'b001) begin
			if (funct7 == 7'h0) begin	// sll
				aluop_EX = 4'b1000;
			end
			
			else if (funct7 == 7'h1) begin	// mulh
				aluop_EX = 4'b0110;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		
		else if (funct3 == 3'b011) begin
			if (funct7 == 7'h1) begin	// mulhu
				aluop_EX = 4'b0111;
			end
			
			else if (funct7 == 7'h0) begin	// sltu
				aluop_EX = 4'b1101;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		
		else if (funct3 == 3'b110) begin	// or
			aluop_EX = 4'b0001;
		end
		
		else if (funct3 == 3'b100) begin	// xor
			aluop_EX = 4'b0010;
		end
		
		else if (funct3 == 3'b101) begin
			if (funct7 == 7'h0) begin	// srl
				aluop_EX = 4'b1001;
			end
			
			else if (funct7 == 7'h20) begin	// sra
				aluop_EX = 4'b1010;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		
		else begin
			regwrite_EX = 1'b0;
		end
		
	end
	
	// i-type instruction
	else if (opcode == 7'h13) begin
		regwrite_EX = 1'b1;
		alusrc_EX = 1'b1;
		regsel_EX = 2'b10;

		if (funct3 == 3'b111) begin		// andi
			alusrc_EX = 1'b1;
			regsel_EX = 2'b10;
		end

		else if (funct3 == 3'b001) begin
			if (funct7 == 7'h0) begin	// slli
				aluop_EX = 4'b1000;
			end
			
			else begin
				regwrite_EX = 1'b0;
			end
		end
		
		else if (funct3 == 3'b000) begin	// addi
			aluop_EX = 4'b0011;
		end
		
		else if (funct3 == 3'b110) begin	// ori
			aluop_EX = 4'b0001;
		end
		
		else if (funct3 == 3'b100) begin	// xori
			aluop_EX = 4'b0010;
		end
		
		else if (funct3 == 3'b101) begin
			if (funct7 == 7'h0) begin	// srli
				aluop_EX = 4'b1001;
			end
			
			else if (funct7 == 7'h20) begin	// srai
				aluop_EX = 4'b1010;
			end
		end
		
		else begin
			regwrite_EX = 1'b0;
		end	
		
		
	end
	
	// u-type instruction
	else if (opcode == 7'h37) begin
		regwrite_EX = 1'b1;
		regsel_EX = 2'b01;			// lui
		
	end
	
	// da silly ones
	else if (opcode == 7'h73) begin
		if (csr == 12'hf02) begin		// csrrw HEX
			regwrite_EX = 1'b0;
			GPIO_we = 1'b1;
		end
		
		else if (csr == 12'hf00) begin		// csrrw SW
			regsel_EX = 2'b00;
			regwrite_EX = 1'b1;
			GPIO_we = 1'b0;
		end
		
		else begin
			regwrite_EX = 1'b0;
		end
	end
	
	else begin
		regwrite_EX = 1'b0;
	end
	
endmodule
