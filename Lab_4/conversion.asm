.data
prompt: .asciz "Enter temperature in Fahrenheit: "
celsius_msg: .asciz "Temperature in Celsius: "
kelvin_msg: .asciz "Temperature in Kelvin: "
result_format: .asciz "\r\n"
constant_273: .float 273.15
f: .float 0
c: .float 0
k: .float 0

.text
.globl main
main:
    flw fa0, f, t3
    flw fa1, c, t3
    flw fa2, k, t3
    
    flw f3, constant_273, t3
    
    # Prompt the user to enter the temperature in Fahrenheit
    la a0, prompt
    li a7, 4
    ecall
    
    # Read the input temperature from the user
    li a7, 5
    ecall

    jal celcius
    jal kelvin
    
    celcius:
    li t0, 5
    li t1, 9
    li t2, 32
    
    fcvt.s.w ft0, t0
    fcvt.s.w ft1, t1
    fcvt.s.w ft2, t2
    
    fsub.s fs2, fa0, ft2
    fdiv.s fs3, ft0, ft1
    fmul.s fa1, fs2, fs3
    
    li a7, 4
    la a0, celsius_msg
    ecall
    
    li a7, 2
    fmv.s fa0, fa1
    ecall
    ret
    
    kelvin:
    flw ft3, constant_273, t3
    fadd.s fa0, fa0, ft3
    
    li a7, 4
    la a0, result_format
    ecall
    
    li a7, 4
    la a0, kelvin_msg
    ecall
    
    li a7, 2
    ecall
