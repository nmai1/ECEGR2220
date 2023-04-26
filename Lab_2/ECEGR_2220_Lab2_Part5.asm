# UNTITLED PROGRAM

	.data		# Data declaration section
	A: .word 0
	B: .word 0
	C: .word 0
	.text

			# Start of code section
main:
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	li t0, 5
	jal ra, AddItUp
	sw ra, A, t6
	
	li t1, 10
	jal ra, AddItUp
	sw ra, B, t5

	lw t1, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8
	
	lw t0, A
	lw t1, B
	add a0, t0, t1
	
	li a7, 10
	ecall
		
AddItUp:
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	li t0, 0
	li t1, 0
	
loop:
	beq t0, a0, endloop
	addi t0, t0, 1
	add  t1, t1, t0
	j loop
	
endloop:
	lw t1, 0(sp)
	lw t0, 4(sp)
	addi sp, sp, 8
	ret
	
	
# END OF PROGRAM
