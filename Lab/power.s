# **************************************************************
# * Program: Power                                             *
# * Description: This program calculates the power of a number *
# **************************************************************
.text

intro: .asciz "\nThis code is for assignment 1: Powers. We are Andrey Petrov(apetrov1) and Yassine el Hattachi(yelhattachi). \n"
base: .asciz "\nEnter the base:\n"
exponent: .asciz "\nEnter the exponent:\n"
input: .asciz "%ld"
output: .asciz "Answer: %ld\n"

.globl main

main:

    #prologue
    pushq %rbp #push the base pointer
    movq %rsp, %rbp #copy stack pointer value to base pointer

    movq $0, %rax #no vector registers in use for printf
    movq $intro, %rdi #param1: intro string
    call printf

    movq $0, %rax #no vector registers in use for printf
    movq $base, %rdi #param1: base string
    call printf

    subq $16, %rsp #reserve space in stack for the input
    movq $0, %rax #no vector registers in use for scanf
    movq $input, %rdi #param1: input format string
    leaq -16(%rbp), %rsi #param2: address of the reserved space
    call scanf
    movq -16(%rbp), %rbx #store base in rbx temporarily

    movq $0, %rax #no vector registers in use for printf
    movq $exponent, %rdi #param1: exponent string
    call printf 

    subq $16, %rsp #reserve space in stack for the input
    movq $0, %rax #no vector registers in use for scanf
    movq $input, %rdi #param1: input format string
    leaq -16(%rbp), %rsi #param2: address of the reserved space
    call scanf
    movq %rsi, %rcx #move exponent to rcx

    call pow

    movq %rax, %rsi #param2: result
    movq $0, %rax #no vector registers in use for printf
    movq $output, %rdi #param1: output string
    call printf

    #epilogue
    movq %rbp, %rsp #clear local variables from stack
    popq %rbp #restore base pointer location

    movq $0 , %rdi 
    call exit

# **************************************************************
# * Subroutine: pow                                            *
# * Description: this subroutine calculates the result of the  *
# * exponentiation                                             *
# * Parameters: inputs: %rbx - base, %rcx - exponent           *
# * output: %rax - result                                      *
# **************************************************************

pow:

    #prologue
    pushq %rbp #push the base pointer
    movq %rsp, %rbp #copy stack pointer value to base pointer

    movq $1, %rax #initialize result to 1

loop: #loop to calculate power
    decq %rcx #decrement exponent/loop counter
    cmpq $0, %rcx #compare if exponent is 0
    jl end #exit loop to end if less than 0
    mulq %rbx #multiply result by base
    jmp loop #repeat loop
end:
    #epilogue
    movq %rbp, %rsp #clear local variables from stack
    popq %rbp #restore base pointer location

    ret #return from subroutine
