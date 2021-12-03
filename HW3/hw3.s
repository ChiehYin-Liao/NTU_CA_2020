.globl __start

.text

__start:
    # read from standard input
    addi a0, zero, 5
    ecall

################################################################################
# write your recursive code here, n is stored in a0
# please store the answer to s0 and jump to "result"
jal ra, f
add s0, a1, zero
jal zero, result

f:
  addi sp, sp , -12   # save return address and n
  sw a0, 0(sp)
  sw ra, 4(sp)

  addi t4, zero, 2
  bge a0, t4, L1      # if n >= 2, go to L1
  
  addi a1, zero, 1;   # else, set return value to 1
  addi sp, sp, 12     # pop stack
  jalr zero, 0(ra)    # return
  
L1:
  srli a0, a0, 1      # n = n/2
  jal ra, f           # call f(n/2)

  sw a1, 8(sp)        # save fact(n/2)

  lw a0, 0(sp)        # restore caller’s n
  
  srli a0, a0, 2      # n = n/4
  jal ra, f           # call f(n/4)
  addi t1, a1, 0      # move result of fact(n/4) to t2
  
  lw a0, 0(sp)        # restore caller’s n
  lw ra, 4(sp)        # restore caller’s return address
  lw a1, 8(sp)        # restore fact(n/2)
  addi sp, sp, 12     # Pop stack

  add a1, a1, t1      # return s0 = n + f(n/2) + f(n/4)
  add a1, a1, a0


  jalr zero,0(ra)       # return
  

################################################################################

result:
    # prints the result in s0
    addi a0, zero, 1
    addi a1, s0, 0
    ecall
    
    # ends the program with status code 0
    addi a0, zero, 10
    ecall

