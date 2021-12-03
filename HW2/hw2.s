.globl __start

.rodata
    op_not_supported_msg: .string "op not supported"
    zero_div_msg: .string "divided by zero"
.text

__start:
    # read A from stdin and store A to s0
    li a0, 5
    ecall
    mv s0, a0
    
    # read op from stdin and store op to s1
    li a0, 5
    ecall
    mv s1, a0
    
    # read B from stdin and store B to s2
    li a0, 5
    ecall
    mv s2, a0

################################################################################ 
# TODO block: Add your code here
#
    li t1, 1
    li t2, 2
    li t3, 3
    
    # before performing operations, test whether it's 
    # divide by zero or op not supported

    # s0 = A, s1 = op, s2 = B
    
    # operation is not 0~3 range
    blt s1, x0, op_not_supported
    bgt s1, t3, op_not_supported
    
    # do operation
    beq x0, x0, calc
    
    
calc:
    beq s1, x0, adder
    beq s1, t1, subtracter  
    beq s1, t2, multiplier   
    beq s1, t3, divider
    
adder:
    add s3, s0, s2 
    beq x0, x0, result 
    
subtracter:
    sub s3, s0, s2
    beq x0, x0, result
    
multiplier:
    mul s3, s0, s2
    beq x0, x0, result
    
divider:    
    # operation is division
    beq s2, x0, zero_div # B = 0 (divided by zero)
    div s3, s0, s2
    beq x0, x0, result
    
################################################################################ 
zero_div:
    li a0, 4
    la a1, zero_div_msg
    ecall
    
    j return


# print the result in s3
result:
    li a0, 1
    mv a1, s3
    ecall
    
    j return


op_not_supported:
    li a0, 4
    la a1, op_not_supported_msg
    ecall
    
    j return
    
    
return:
    li a0, 10
    ecall

