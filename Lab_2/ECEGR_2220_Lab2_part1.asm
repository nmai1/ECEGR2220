# UNTITLED PROGRAM

	.data
	
	Z: .word 0		# Data declaration section

	.text
	
	

main:			# Start of code section
	
	li t0, 15
	li t1, 10
	li t2, 5
	li t3, 2
	li t4, 18
	li t5, -3
	sub t1, t0, t1 #t1 = A - B
	mul t3, t2, t3 #t3 = C * D
	sub t5, t4, t5 #t5 = E - F
	div t4, t0, t2 #t4 = A / C
	add t1, t1, t3 #t1 = (A - B) + (C * D)
	add t1, t1, t5 #t1 = (A - B) + (C * D) + (E - F)
	sub t1, t1, t4 #t1 = (A - B) + (C * D) + (E - F) - (A / C)
	sw  t1, Z, t6
	
	li a7, 1	# system call code for print_int
	lw a0, Z	# integer to print
	ecall		# print it
	
# END OF PROGRAM