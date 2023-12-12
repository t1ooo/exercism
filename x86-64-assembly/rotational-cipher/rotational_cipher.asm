section .text

%macro rotate_char 3 ; (char, shift, case_shift)
    movsx rax, %1

    sub rax, %3
    add rax, %2

    mov rdx, 0
    mov rcx, 26
    div rcx

    add rdx, %3
    mov %1, dl
%endmacro

; ((ch % 97) + shift) % 26 + 97;
%macro rotate_lower 2 ; (char, shift)
    rotate_char %1, %2, 97
%endmacro

; ((ch % 65) + shift) % 26 + 65;
%macro rotate_upper 2 ; (char, shift)
    rotate_char %1, %2, 65
%endmacro

; min <= value <= max
%macro between 4 ; (value, min, max, success_label)
    mov r11b, %1
    sub r11b, %2
    cmp r11b, %3-%2
    jbe %4
%endmacro

global rotate
rotate:
    ; rdi = const char *text
    ; rsi = int shift_key
    ; rdx = char *buffer

    mov r8, 0
    mov r9, rdx
loop:
    mov r10b, byte [r8 + rdi]

    cmp r10b, 0
    je loop_break

    between r10b, 65, 90, upper_case
    between r10b, 97, 122, lower_case

    jmp loop_continue

upper_case:
    rotate_upper r10b, rsi
    jmp loop_continue

lower_case:
    rotate_lower r10b, rsi
    jmp loop_continue

loop_continue:
    mov byte[r8 + r9], r10b

    inc r8
    jmp loop

loop_break:
    mov byte[r8 + r9], 0 ; add null terminator
    ret
