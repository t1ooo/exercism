; c algo:
;
; int is_pangram (char *s) {
;     int mask = 0;
;     for (;*s;s++) {
;         unsigned char ch = *s;
;         // uppercase
;         if ('a'<=ch) {
;           ch -= 32;
;         }
;         // A to 0
;         ch = ch - 'A';
;         // continue if not alpha char
;         if (25 < ch ) {
;           continue;
;         }
;         // set bit mask
;         mask |= 1 << ch;
;     }
;     return mask == 0b11111111111111111111111111;
; }

section .text
global is_pangram

is_pangram:
    mov r8, 0 ; mask

loop1:
    mov cl, byte [rdi]; char

    cmp cl, 0
    je loop1_break

    cmp cl, 'a'       ; if char >= 'a'
    jae uppercase
    jmp uppercase_end

uppercase:
    sub cl, 32
uppercase_end:

    sub cl, 'A'

    cmp cl, 25        ; if char > 25
    ja loop1_continue

    ; mask |= 1 << char
    mov rdx, 1
    shl rdx, cl
    or r8, rdx

loop1_continue:
    inc rdi
    jmp loop1

loop1_break:

    mov rax, 0
    cmp r8, 11111111111111111111111111b
    sete al
    ret

