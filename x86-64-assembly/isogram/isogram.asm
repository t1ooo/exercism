; c algo:
;
; int is_isogram (char *s) {
;     int bitmask = 0;
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
;         int flag = 1 << ch;
;         // return 0 if bitmask already contains char
;         if ( bitmask & flag ) {
;             return 0;
;         }
;         // set char to bitmask
;         bitmask |= flag;
;     }
;     return 1;
; }

section .text
global is_isogram

is_isogram:
    ; mask
    mov rdx, 0

loop1:
    ; set default value (0) to return result
    mov rax, 0

    ; current char
    mov cl, byte [rdi]

    cmp cl, 0
    je loop1_break

    ; if char >= 'a'
    cmp cl, 'a'
    jae uppercase
    jmp uppercase_end

uppercase:
    sub cl, 32
uppercase_end:

    sub cl, 'A'

    ; if char > 25
    cmp cl, 25
    ja loop1_continue

    ; flag = 1 << char
    mov r9, 1
    shl r9, cl

    ; cond = bitmask & flag
    mov r10, r9
    and r10, rdx

    ; if cond != 0
    cmp r10, 0
    jne return

    ; bitmask |= flag;
    or rdx, r9

loop1_continue:
    inc rdi
    jmp loop1

loop1_break:
    ; set 1 to return result
    mov rax, 1

return:
    ret

