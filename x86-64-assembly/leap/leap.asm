section .text
global leap_year

; args:
;   %1 = dividend
;   %2 = divisor
; result:
;   rax = quotient
;   rdx = remainder
%macro _div 2
   mov rax, %1
   cqo
   mov r8, %2
   div r8
%endmacro

; leap_year algo:
;   if (year % 400 == 0) return 1
;   if (year % 4 != 0)   return 0
;   if (year % 100 == 0) return 0
;   return 1

; args:
;  rdi = year
leap_year:
    ; if (year % 400 == 0) return 1
    _div rdi, 400
    cmp rdx, 0
    je return_true

    ; if (year % 4 != 0) return 0
    _div rdi, 4
    cmp rdx, 0
    jne return_false

    ; if (year % 100 == 0) return 0
    _div rdi, 100
    cmp rdx, 0
    je return_false

return_true:
    mov rax, 1
    ret

return_false:
    mov rax, 0
    ret
