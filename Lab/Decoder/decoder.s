.text

.include "final.s"

format: .asciz "%lc"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	pushq %rbx # store callee saved register's value on the stack for restoration later
	pushq %r12 # store callee saved register's value on the stack for restoration later
	pushq %r13 # store callee saved register's value on the stack for restoration later
	pushq $0 # 16 allign the stack
	
	movq %rdi, %rbx # transfer $MESSAGE into rbx to have a non-changing copy
	movq $0, %r12 #prepare register for looping, register will hold number of times to print characters
	movq $0, %r13 #prepare register for looping, register will hold offset for navigation
	
navLoop:
printLoop:

	movq (%rbx, %r13, 8), %rsi # store copy of a row of $MESSAGE used for printing a character
	shlq $56, %rsi # isolate last two digits (character to print)	
	shrq $56, %rsi # isolate last two digits

	movq $0, %rax # no vector arguements for printf
	movq $format, %rdi # param 1: format string
	call printf # param 2: character to print

	cmpq $0, %r12 # check if # of times to repeat the print is 0 and don't change register otherwise
	jg end
	
	movq (%rbx, %r13, 8), %r12 # store copy of a row of $MESSAGE used for printing
	shlq $48, %r12 # isolate second to last two digits (# of times to print)
	shrq $56, %r12 # isolate second to last two digits
end:
	decq %r12 #decrement # of times to print/loop 

	cmpq $0, %r12 #check if another printing loop needs to happen
	jg printLoop

	movq (%rbx, %r13, 8), %r13 # store copy of a row of $MESSAGE used for navigating the data
	shlq $16, %r13 # isolate the middle eight digits (index to navigate to)
	shrq $32, %r13 # isolate the middle eight digits

	cmpq $0, %r13 # check if the end of the sequence is reached (navigation index is 0)
	jg navLoop


	popq %r13 # pop useless stack allignment 0	
	popq %r13 # restore register to original value
	popq %r12 # restore register to original value
	popq %rbx # restore register to original value

	# epilogue
	movq	%rbp, %rsp		# clear local variables from stack
	popq	%rbp			# restore base pointer location 
	ret

main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi	# first parameter: address of the message
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program
