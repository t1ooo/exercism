section .text

; uint64_t square(int64_t number) {
;     if (number <= 0) return 0;
;     if (number > 64) return 0;
;     return UINT64_C(1) << (number-1); // 2^(number-1);
; }
global square
square:
    ; rdi = number

    mov rax, 0
    
    cmp rdi, 0
    jbe return

    cmp rdi, 64
    ja return

    dec rdi

    mov rcx, rdi
    mov rax, 1
    shl rax, cl

return:
    ret

; uint64_t total(void) {
;     return UINT64_C(-1); // (2^64)-1
; }
global total
total:
    mov rax, -1
    ret