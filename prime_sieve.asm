; Sieve of Eratosthenes in Linux x86_64 NASM



PRIME   equ     1
COMP    equ     0
LIMIT   equ     10000000

        global  main
        extern  printf

        section .data
fmt:    db  "%d", 10,
bools:  times LIMIT * 2 db PRIME

        section .text
main:
        push    rbx

        mov     rcx, 2
        mov     word [bools], COMP

.loop:
        cmp     byte [bools + rcx], PRIME
        call    mul_fn

        inc     rcx
        cmp     rcx, LIMIT
        je      print_primes

        jmp     .loop

mul_fn: 
        mov     rax, rcx
        shl     rax, 1
.loop:
        mov     byte [bools + rax], COMP
        add     rax, rcx

        cmp     rax, LIMIT
        jl      .loop

        ret

print_primes:
        xor     rcx, rcx
.loop:
        cmp     rcx, LIMIT
        je      exit

        inc     rcx
        cmp     byte [bools + rcx], COMP
        je      .loop

        push    rcx
        mov     rsi, rcx
        mov     rdi, fmt
        xor     rax, rax
        call    printf WRT ..plt
        pop     rcx

        jmp     .loop

exit:
	mov     rax, 60
	mov     rdi, 0
	syscall
