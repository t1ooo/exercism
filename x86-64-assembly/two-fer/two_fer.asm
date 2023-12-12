%macro copy_mem2mem 2 ; (dest, src)
   mov cl, byte %2
   mov byte %1, cl
%endmacro

section .rodata

head: db "One for ", 0
name: db "you", 0
tail: db ", one for me.", 0

section .text
global two_fer

; void strcat(char *dest, const char *src) {
;    while (*dest)
;      dest++;
;
;    while ((*dest++ = *src++));
; }
strcat:
    ; rdi = dest
    ; rsi = src

L1:
    cmp byte [rdi], 0
    lea rdi, [rdi + 1]
    jne L1


    mov rax, 0
L2:
    copy_mem2mem [rdi + rax - 1], [rsi + rax]
    inc rax
    test cl, cl
    jne L2
    
    ret


; void two_fer(char *name, char *buf) {
;    buf[0] = '\0';
;
;    static char str1[] = "One for ";
;    static char str2[] = ", one for me.";
;
;    strcat(buf, str1);
;    strcat(buf, name ? name : "you");
;    strcat(buf, str2);
; }
two_fer:
    ; rdi = name
    ; rsi = buffer

    ; add a null terminator for the strcat procedure to work correctly
    mov byte [rsi], 0

    ; save rdi, rsi register values for calling strcat procedure
    mov r8, rdi ; name
    mov r9, rsi ; buffer

    ; append head
    mov rdi, r9   ; dest
    mov rsi, head ; src
    call strcat

    ; append name
    cmp r8, 0  ;  if name empty
    je no_name ; then go to no_name
               ; else fall-through

    mov rdi, r9 ; dest

a_name:
    mov rsi, r8 ; src
    jmp end

no_name:
    mov rsi, name ; src

end:
    call strcat

    ; append tail
    mov rdi, r9   ; dest
    mov rsi, tail ; src
    call strcat
    ret
