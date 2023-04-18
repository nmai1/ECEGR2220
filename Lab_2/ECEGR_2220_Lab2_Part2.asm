# UNTITLED PROGRAM

	.data		# Data declaration section
	
	A: .word 10
	B: .word 15
	C: .word 6
	D: .word 0
	Z: .word 0
	
	.text

main:			# Start of code section
	
	lw t0, A
	lw t1, B
	lw t2, C
	lw t4, Z
	li a5, 5
	li a7, 7
	li a1, 1
	li a2, 2
	li a3, 3
	
	blt t0, t1, temp
	
	bgt t0, t1, zTwo
	addi a0, t2, 1
	beq a0, a7, zTwo
	
	j nextcheck

	temp:
	bgt t2, a5, zOne
	
	nextcheck:
	li t4, 3
	j exit
	
	zOne:
	li t4, 1
	j exit
	
	zTwo:
	li t4, 2
	j exit
	
	zThree:
	li t4, 3
	j exit
	
	exit:
	beq t4, a1, case1
	beq t4, a2, case2
	beq t4, a3, case3 
	j default
	
	case1:
	li t4, -1
	j exit2
	
	case2:
	li t4, -2
	j exit2
	
	case3:
	li t4, -3
	j exit2
	
	default:
	li t4, 0
	
	exit2:
	sw t4, Z, t6
	
	li a7, 1	# system call code for print_int
	lw a0, Z	# integer to print
	ecall		# print it
	
# END OF PROGRAM
