; Sieve of Eratosthenes in Linux x86_64 NASM
;
; This uses a list of boolean true/false values with the
; definitions of the values defined directly below to get
; a list of the positions of prime numbers and then just
; prints them with glibc printf()



PRIME   equ     1
COMP    equ     0               ;  1 means prime, 0 means composite
LIMIT   equ     10000000        ; LIMIT: the number to go up to 

        global  main
        extern  printf

        section .data
fmt:    db  "%d", 10,
bools:  times LIMIT * 2 db PRIME

        section .text
main:
        push    rbx

        mov     rcx, 2                  ; the first prime number is 2
        mov     word [bools], COMP      ; set both 0 and 1 to COMP

.loop:
        cmp     byte [bools + rcx], PRIME
        call    mul_fn

        inc     rcx
        cmp     rcx, LIMIT              ; check if we're at the limit
        je      print_primes

        jmp     .loop

mul_fn: 
        mov     rax, rcx                ; moves out current prime number to the rax register
        shl     rax, 1
.loop:
        mov     byte [bools + rax], COMP        ; set the multiple as composite
        add     rax, rcx                        ; step up by the original prime

        cmp     rax, LIMIT      ; check if we're at the limit
        jl      .loop           ; if less than the limit, loop again

        ret                     ; return from the function to out position in main.loop

print_primes:
        xor     rcx, rcx
.loop:
        cmp     rcx, LIMIT      ; check if we're at the limit
        je      exit

        inc     rcx                             ; go to the next number
        cmp     byte [bools + rcx], COMP        ; check if it's composite
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