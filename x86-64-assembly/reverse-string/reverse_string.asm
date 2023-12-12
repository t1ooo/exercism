section .text
global reverse

; c algo:
; void reverse (char *s) {
;    char *last = s;
;    while (*last) {
;        last++;
;    }
;    last--; // null terminator
;
;    char *first = s;
;    char tmp;
;    while(first < last) {
;        // swap
;        tmp = *last;
;        *last = *first;
;        *first = tmp;
; 
;        first++;
;        last--;
;    }
;}

reverse:
    mov r8, rdi ; first
    mov r9, rdi ; last

L1:    
    cmp byte [r9], 0
    je L1_END
    lea r9, [r9 + 1]
    jmp L1
L1_END:

    dec r9 ; null terminator
   
L2:    
    cmp r8, r9
    ja L2_END
    mov cl, byte [r9]
    mov dl, byte [r8]
    mov byte[r9], dl
    mov byte[r8], cl
    inc r8
    dec r9
    jmp L2
L2_END: 
    
    ret




