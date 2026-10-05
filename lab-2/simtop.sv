/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	        .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);
	
	initial begin
		SW = 18'h000000000000000001; #10
		if (HEX0 !== 7'b111001) $display("HEX0 showing 1 passed.");

		SW = 18'b000000000000001111; #10
		if (HEX0 !== 7'b111001) $display("HEX0 showing 1 passed.");

		SW = 18'h000000000000010000; #10
		if (HEX0 !== 7'b111001) $display("HEX1 showing 1 passed.");

		SW = 18'b000000000011110000; #10
		if (HEX0 !== 7'b111001) $display("HEX1 showing 1 passed.");

		SW = 18'h000000000000000001; #10
		if (HEX0 !== 7'b111001) $display("HEX2 showing 1 passed.");

		SW = 18'b000000000000001111; #10
		if (HEX0 !== 7'b111001) $display("HEX2 showing 1 passed.");

		SW = 18'h000000000010000000; #10
		if (HEX0 !== 7'b111001) $display("HEX3 showing 1 passed.");

		SW = 18'b000000111100000000; #10
		if (HEX0 !== 7'b111001) $display("HEX3 showing 1 passed.");

		SW = 18'h000000100000000000; #10
		if (HEX0 !== 7'b111001) $display("HEX4 showing 1 passed.");

		SW = 18'b001111000000000000; #10
		if (HEX0 !== 7'b111001) $display("HEX4 showing 1 passed.");

		SW = 18'h01000000000000000; #10
		if (HEX0 !== 7'b111001) $display("HEX5 showing 1 passed.");

		SW = 18'b11000000000000000; #10
		if (HEX0 !== 7'b011_0000) $display("HEX5 showing 1 passed.");
	end





endmodule

