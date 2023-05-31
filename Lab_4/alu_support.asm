
.data

.text

li t0, 0x6B87F5A2
li t1, 0xE9D24C1F

add a0, t0, t1

sub a1, t0, t1

and a2, t0, t1

or a3, t0, t1

li t1, 1
srl a4, t0, t1

li t1, 2
srl a5, t0, t1

li t1, 3
srl a6, t0, t1

li t1, 1
sll a7, t0, t1

li t1, 2
sll s2, t0, t1

li t1, 3
sll s3, t0, t1


addi s4, t0, 0x00000123

andi s5, t0, 0x00000123

ori  s6, t0, 0x00000123

srli s7, t0, 3

slli s8, t0, 3

li t0, 0x108108EF
li t1, 0x108108EF
sub s9, t0, t1