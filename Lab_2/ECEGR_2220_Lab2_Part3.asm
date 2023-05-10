# UNTITLED PROGRAM

	.data		# Data declaration section
	Z: .word 2
	I: .word

	.text

main:			# Start of code section
	
	li t0, 0
	
	li t1, 20
	li t2, 2
	addi t3, zero, 0
	
	for:
	bgt  t3, t1, nextcheck
	addi t2, t2, 1
	addi t3, t3, 2
	j for
	
	nextcheck:
	addi t2, t2, 1
	li t4, 100
	blt t2, t4, nextcheck
	
	while1:
	bgtz t3, loop
	j end
	
	loop:
	addi t2, t2, -1
	addi t3, t3, -1
	j while1
	
	end:
	sw t2, Z, t6
	li a7, 1	# system call code for print_int
	lw a0, Z	# integer to print
	ecall		# print it
	
# END OF PROGRAM
