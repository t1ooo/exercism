;int find(int *array, int size, int value) {
;  int left = 0;
;  int right = size - 1;
;  while (left <= right) {
;    int i = (right+left)/2;
;    if (value == array[i]) {
;      return i;
;    }
;    if (value < array[i]) {
;      right=i-1;
;    } else {
;      left=i+1;
;    }
;  }
;  return -1;
;}

section .text
global find
find:
    ; rdi = int *array
    ; rsi = int size
    ; rdx = int value

    mov r8, 0       ; left
    lea r9, [rsi-1] ; right

loop:
    cmp r8, r9
    jg loop_break

    ; int i = (right+left)/2;
    mov rax, r8
    add rax, r9
    sar rax, 1

    cmp edx, dword [rdi+rax*4]
    je return
    jl right

    lea r8, [rax+1] ; left=i+1
    jmp loop_continue

right:
    lea r9, [rax-1] ; right=i-1

loop_continue:
    jmp loop

loop_break:
    mov rax, -1
    ret

return:
    ret
