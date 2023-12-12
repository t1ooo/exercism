section .text

; c algo:
;
; int is_equals(const char *first, const char *second) {
;     int i = 0;
;     while (1) {
;         if (
;             first[i] == 0
;             || second[i] == 0
;             || first[i] != second[i]
;         ) {
;             break;
;         }
;         i++;
;     }
;     if (first[i] != 0 || second[i] != 0) return 0;
;     return 1;
; }
is_equals:
    mov rcx, 0
is_equals.loop:
    mov r8b, byte [rdi + rcx]
    mov r9b, byte [rsi + rcx]

    cmp r8b, 0
    je is_equals.loop.break

    cmp r9b, 0
    je is_equals.loop.break

    cmp r8b, r9b
    jne is_equals.loop.break

    inc rcx
    jmp is_equals.loop
is_equals.loop.break:

    mov rax, 0

    cmp r8b, 0
    jne is_equals.return

    cmp r9b, 0
    jne is_equals.return

    mov rax, 1

is_equals.return:
    ret


; c algo:
;
; const char *clrs[10] = {"black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"};
;
; int color_code(const char *color) {
;     for (int i=0; i<10; i++) {
;         if (is_equals(clrs[i], color)) {
;             return i;
;         }
;     }
;     return -1;
; }
global color_code
color_code:
    push r12
    push r13
    push r15

    mov r12, rdi; color
    mov r13, clrs
    
    mov r15, 0; index
color_code.loop:
    cmp r15, 10
    je color_code.return_index

    mov rdi, [8*r15 + r13]
    mov rsi, r12
    call is_equals

    cmp rax, 1
    je color_code.return_index

    inc r15
    jmp color_code.loop
; color_code.loop end

    ; return default
    mov rax, -1
    jmp color_code.return

color_code.return_index:
    mov rax, r15

color_code.return:
    pop r15
    pop r13
    pop r12
    ret

global colors
colors:
    mov rax, clrs
    ret

section .data
str_0: db  "black", 0
str_1: db  "brown", 0
str_2: db  "red", 0
str_3: db  "orange", 0
str_4: db  "yellow", 0
str_5: db  "green", 0
str_6: db  "blue", 0
str_7: db  "violet", 0
str_8: db  "grey", 0
str_9: db  "white", 0

clrs: dq str_0, str_1, str_2, str_3, str_4, str_5, str_6, str_7, str_8, str_9, 0