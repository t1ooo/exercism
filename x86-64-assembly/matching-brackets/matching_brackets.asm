; c algo
; int is_paired(const char *str) {
;     char stack[100];
;     int i = 0;
;     while(*str) {
;         switch (*str) {
;             case '[': stack[i++] = ']'; break;
;             case '{': stack[i++] = '}'; break;
;             case '(': stack[i++] = ')'; break;
;             case ']':
;             case '}':
;             case ')':
;                 i--;
;                 if (i < 0 || stack[i] != *str) {
;                     return 0;
;                 }
;                 break;
;         }
;         str++;
;     }
;     return i == 0;
; }


%macro save_stack_pointer 0
    mov rcx, rsp
%endmacro

%macro is_stack_empty 0
    cmp rcx, rsp
%endmacro

%macro restore_stack_poiter 0
    mov rsp, rcx
%endmacro

%macro process 2 ;(char, push_char)
    mov r10b, %2 ; char for push to stack
    cmp r9b, %1
    je push

    cmp r9b, %2
    je check
%endmacro

section .text

global is_paired
is_paired:
    mov rax, 0          ; set default return value
    save_stack_pointer

    mov r8, 0 ; index
loop:
    mov r9b, byte [rdi + r8] ; current char

    cmp r9b, 0
    je break

    process '[',']'
    process '{','}'
    process '(',')'

    jmp continue

push:
    push r10
    jmp continue

check:
    is_stack_empty     ; return false if stack empty
    je return

    pop r11
    cmp r11b, r9b      ; return false if current and poped chars not equal
    jne return

continue:
    inc r8
    jmp loop

break:
    is_stack_empty
    sete al

return:
    restore_stack_poiter
    ret
