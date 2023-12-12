; args:
;   %1 = item
;   %2 = score
; result:
;   rax
%macro check 2 ;(item, score)
    ; flag = 1 << item
    mov rax, 1
    mov rcx, %1
    shl rax, cl

    ; !!(flag & score)
    and rax, %2
    setnz al
%endmacro

section .text

global allergic_to
allergic_to:
    check rdi, rsi
    ret

; void list(unsigned int score, struct item_list *list) {
;   for(int i=0; i<MAX_ITEMS; i++) {
;     if (allergic_to(i, score)) {
;       list->items[i] = i;
;       list->size += 1;
;     }
;   }
; }
global list
list:
    ; rdi = score
    ; rsi = item_list

    mov dword [rsi], 0 ; reset item_list.size

    mov r8, 0 ; item
    mov r9, 0 ; item_list.items index
loop:
    cmp r8, 8
    je loop_break

    check r8, rdi
    cmp rax, 0
    je loop_continue

    mov dword [rsi + 4*r9 + 4], r8d ; set value to item_list.items
    inc r9

    inc dword [rsi] ; inc item_list.size

loop_continue:
    inc r8
    jmp loop

loop_break:

    ret