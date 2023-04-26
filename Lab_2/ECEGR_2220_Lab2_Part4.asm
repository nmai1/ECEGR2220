# UNTITLED PROGRAM

	.data		# Data declaration section
	A: .word 20
	B: .word 1, 2, 4, 8, 16
	.text

main:			# Start of code section
	la t1, A
	la t2, B		
	li t0, 0
	li a6, 5
	li a5, 2
	
	beq t0, x0, for
	
	for:
	lw t3, 0(t2)
	addi t3, t3, -1
	sw t3, 0(t1)
	addi t2, t2, 4
	addi t1, t1, 4
	addi t0, t0, 1
	blt t0, a6, for
	bge t0, a6, minus
	
	minus:
	addi x1, x1, -1
	j while
	
	while:		
	lw t3, 0(t2)
	lw t4, 0(t1)
	add t5, t1, t2
	mul t5, t5, a5
	sw  t5, 0(t1)
	addi t2, t2, 4
	addi t1, t1, 4
	addi t0, t0, -1
	bge t0, x0, while
	j end
	
	end:
	sw t1, A, t6
	li a7, 1	# system call code for print_int
	lw a0, A	# integer to print
	ecall		# print it
	
# END OF PROGRAM
