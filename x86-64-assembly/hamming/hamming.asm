; c algo :
; int distance(const char *a, const char *b) {
;     int dist = 0;
;     int i = 0;
;     while(a[i] && b[i]) {
;         dist += (a[i] == b[i]) ? 0 : 1;
;         i++;
;     }
;     return (a[i] != 0 || b[i] != 0) ? -1 : dist;
; }

section .text
global distance
distance:
    mov rax, 0 ; distance
    mov r8, 0  ; index

loop:
    mov r10b, byte [r8 + rdi]
    mov r11b, byte [r8 + rsi]

    cmp r10b, 0
    je loop_break

    cmp r11b, 0
    je loop_break

    cmp r10b, r11b
    setne r9b
    add rax, r9

    inc r8
    jmp loop
loop_break:

    cmp r10b, 0
    jne return_error

    cmp r11b, 0
    jne return_error

    ret

return_error:
    mov rax, -1
    ret