section .text

global square_of_sum
square_of_sum:
    mov rax, rdi   
    inc rax       ; (n+1) 

    imul rax, rdi ; n(n+1) 

    cqo           ; (n(n+1)/2)
    mov r8, 2
    div r8

    imul rax, rax ; (n(n+1)/2)^2
    ret

global sum_of_squares
sum_of_squares:
    mov r8, rdi
    inc r8        ; (n+1)

    mov rax, rdi  ; (2n+1)
    mov r9, 2
    imul rax, r9
    inc rax

    imul rax, r8  ; n(n+1)(2n+1)
    imul rax, rdi

    cqo           ; n(n+1)(2n+1)/6
    mov r10, 6
    div r10

    ret

global difference_of_squares
difference_of_squares:
    push r12

    call sum_of_squares
    mov r12, rax
    
    call square_of_sum

    sub rax, r12  ; square_of_sum - sum_of_squares
    
    pop r12
    ret