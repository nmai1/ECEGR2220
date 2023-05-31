
.data

.text

main:
li a1, 3
jal Fib
add t1, zero, t0

li a1, 10
jal Fib
add t2, zero, t0

li a1, 20
jal Fib
add s0, zero, t0

j end


Fib:
li t5, 1
blez a1, if 
beq a1, t5, elseif 

addi sp, sp, -4
sw ra, 0(sp)  
addi sp, sp, -4 
sw a1, 0(sp) 

addi a1, a1, -1 

jal Fib

add a2, zero, t0 

lw a1, 0(sp) 
addi sp, sp, 4
lw ra, 0(sp)
addi sp, sp, 4

addi sp, sp, -4
sw ra, 0(sp)
addi sp, sp, -4
sw a1, 0(sp)
addi sp, sp, -4
sw a2, 0(sp)

addi a1, a1, -2

jal Fib

add a3, zero, t0

lw a2, 0(sp)
addi sp, sp, 4
lw a4 0(sp)
addi sp, sp, 4
lw ra, 0(sp)
addi sp, sp, 4

add t0, a2, a3
ret

if:
addi t0, zero, 0
ret 

elseif:
addi t0, zero, 1
ret

end:
li a7, 10
ecall