section .text
global to_rna

%define G 'G'
%define C 'C'
%define T 'T'
%define A 'A'
%define U 'U'
%define NUL 0

to_rna:
    ; rdi = dna
    ; rsi = buffer

loop:
    cmp byte[rdi], NUL ; if char is NUL
    je loop_end        ; goto loop_end

    cmp byte[rdi], G   ; if char is G
    je case_g          ; goto case_g

    cmp byte[rdi], C   ; if char is C
    je case_c          ; goto case_c

    cmp byte[rdi], T   ; if char is T
    je case_t          ; goto case_t

    cmp byte[rdi], A   ; if char is A
    je case_a          ; goto case_a

case_g:
    mov byte [rsi], C ; add C to buffer
    jmp finally

case_c:
    mov byte [rsi], G ; add G to buffer
    jmp finally

case_t:
    mov byte [rsi], A ; add A to buffer
    jmp finally

case_a:
    mov byte [rsi], U ; add U to buffer
    jmp finally

finally:
    lea rdi, [rdi + 1] ; next dna char
    lea rsi, [rsi + 1] ; next buffer char
    jmp loop

loop_end:

    mov byte [rsi], NUL  ; add NUL to buffer
    ret

