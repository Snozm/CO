# ******************************************************************
# * Program: Factorial                                             *
# * Description: This program calculates the factorial of a number *
# ******************************************************************
.text

intro: .asciz "\nThis code is for assignment 2: Recursion. We are Andrey Petrov(apetrov1) and Yassine el Hattachi(yelhattachi). \n"
base: .asciz "\nEnter the base:\n"
exponent: .asciz "\nEnter the exponent:\n"
factorialPrompt: .asciz "\nEnter a number to get the factorial of:\n"
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
    movq $factorialPrompt, %rdi #param1: factorial string
    call printf

    subq $16, %rsp #reserve space in stack for the input
    movq $0, %rax #no vector registers in use for scanf
    movq $input, %rdi #param1: input format string
    leaq -16(%rbp), %rsi #param2: address of the reserved space
    call scanf
    movq -16(%rbp), %rdi #store number in rdi to be used in factorial subroutine

    call factorial

    movq %rax, %rsi #param2: result
    movq $0, %rax #no vector registers in use for printf
    movq $output, %rdi #param1: output string
    call printf

    #epilogue
    movq %rbp, %rsp #clear local variables from stack
    popq %rbp #restore base pointer location

    movq $0, %rdi 
    call exit

factorial:

    #base case
    cmpq $1, %rdi #compare if number is 1
    jle finish #exit loop to finish if less than 1

    #prologue
    pushq %rbp #push the base pointer
    movq %rsp, %rbp #copy stack pointer value to base pointer

    decq %rdi #decrement number
    call factorial #recursive call
    incq %rdi #increment number
    mulq %rdi #multiply result by number


    #epilogue
    movq %rbp, %rsp #clear local variables from stack
    popq %rbp #restore base pointer location

return:

    ret #return from subroutine

finish:

    mov $1, %rax #initialize result to 1
    jmp return #exit subroutine

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
    decq %rsi #decrement exponent/loop counter
    cmpq $0, %rsi #compare if exponent is 0
    jl end #exit loop to end if less than 0
    mulq %rdi #multiply result by base
    jmp loop #repeat loop
end:
    #epilogue
    movq %rbp, %rsp #clear local variables from stack
    popq %rbp #restore base pointer location

    ret #return from subroutine
