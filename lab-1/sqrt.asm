# Copyright jbrsnow 2026
.text

# t0 -> input
# t1 -> step
# t2 -> guess
# t3 -> guess^2_low
# t4 -> guess^2_high
# t5 -> guess^2 (g^2)

main:
	li a7, 5	# get input
	ecall
	mv t0, a0
	
	li t2, 0	# set guess to 0
	li t1, 4194304	# set step to 256 in (32, 14)
	j loop
	
loop:
	# store high and low regs for g^2
	mul t3, t2, t2
	mulh t4, t2, t2
	
	# shift for (32, 14) and combine
	slli t4, t4, 18
	srli t3, t3, 14
	or t5, t4, t3
	
	beq t1, zero, exit	# step == 0
	beq t5, t0, exit	# g^2 == input
	bltu t5, t0, upper	# g^2 < input
	bgtu t5, t0, lower	# g^2 > input

upper:
	# increase guess by step since g^2 < input
	add t2, t2, t1
	srli t1,t1, 1	# step / 2
	j loop
	
lower:
	# decrease guess by step since g^2 > input
	sub t2, t2, t1
	srli t1, t1, 1	# step / 2
	j loop

exit:
	mv a0, t2
	li a7, 1	# print guess
	ecall
	
	li a7, 10	# exit
	ecall
