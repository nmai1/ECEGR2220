# UNTITLED PROGRAM

	.data		# Data declaration section
	Z: .word 2
	I: .word

	.text

main:			# Start of code section
	lw t1, Z
	lw t2, I
	li a4, 20
	li a5, 100
	
	li t2, 0
	beq t2, x0, for
	
	for:
	ble  t2, a4, nextcheck
	bgt  t2, a4, end
	
	nextcheck:
	addi t2, t2, 2
	addi t1, t1, 1
	blt  t2, a5, while1
	
	while1:
	blt t2, a5, do
	
	while2:
	bgt t2, x0, do2
	
	do:
	addi t1, t1, 1
	j while2
	
	do2:
	addi t1, t1, -1
	addi t2, t2, -1
	j for

	end:
	sw t1, Z, t6
	li a7, 1	# system call code for print_int
	lw a0, Z	# integer to print
	ecall		# print it
	
# END OF PROGRAM
