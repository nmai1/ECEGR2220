# UNTITLED PROGRAM

	.data		# Data declaration section
	A: .word 0
	B: .word 0
	C: .word 0
	.text

			# Start of code section
main:
	li t0, 5
	li t1, 10
	
	mv a0, t0
	jal ra, AddItUp
	sw a0, A, t6
	
	mv a0, t1
	jal ra, AddItUp
	sw, a0, B, t6
	
	lw t2, A
	lw t3, B
	add t4, t2, t3
	sw t4, C, t6
	
	li a7, 10
	ecall
		
AddItUp:
	addi sp, sp, -8
	sw ra, 4(sp)
	sw s0, 0(sp)
	addi s0, sp, 8
	
	sw zero, 0(s0)
	sw zero, 4(s0)
	
loop:
	lw t0, 0(s0)
	beq t0, a0, endloop
	
	lw t1, 4(s0)
	addi t2, t0, 1
	add t3, t1, t2
	sw t3, 4(s0)
	
	addi t0, t0, 1
	sw t0, 0(s0)
	j loop
	
endloop:
	lw a0, 4(s0)

lw ra, 4(sp)
lw s0, 0(sp)
addi sp, sp, 8
jr ra
	
	
# END OF PROGRAM
