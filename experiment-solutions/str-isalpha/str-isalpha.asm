%include "debug.asm"

section .text
global str_isalpha
str_isalpha:
    cmp byte [rdi], 0 ; if str empty
    je  EXIT_FALSE    ; goto EXIT_FALSE
                      ; else fall-through


LOOP:  
    cmp byte [rdi], 0 ; if *str == 0
    je EXIT_TRUE      ; goto EXIT_TRUE
                      ; else fall-through

    movsx ebp, byte [rdi] ; char_code = (int)str[0]

    cmp ebp, 65 ; a = 65 <= char_code
    setge al

    cmp ebp, 90 ; b = char_code <= 90
    setle bl

    cmp ebp, 97 ; c = 97 <= char_code
    setge cl

    cmp ebp, 122 ; d = char_code <= 122
    setle dl

    and al, bl ; ab = a && b
    and cl, dl ; cd = c && d

    or al, cl ; is_alpha = ab || cd;

    cmp al, 0     ; if !is_alpha
    je EXIT_FALSE ; goto EXIT_FALSE
                  ; else fall-through

    lea rdi, [rdi + 1] ; str++
    jmp LOOP           ; continue loop
  
EXIT_TRUE:
    mov rax, 1
    ret
 
EXIT_FALSE:
    mov rax, 0
    ret

