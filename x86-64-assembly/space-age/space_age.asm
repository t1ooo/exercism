section .text

; c algo:
;
; float age(enum planet planet, int seconds) {
;   float factors[] = {...};
;   int earth_period = 31557600;
;   return seconds / (earth_period * factors[planet]);
; }

global age
age:
    ; rdi = planet
    ; rsi = seconds

    mov r8, factors
    mov r10, earth_period
    mov r11, [8*rdi + r8] ; load factor

    cvtsi2ss xmm0, rsi         ; seconds
    cvtsi2ss xmm1, dword [r10] ; earth_period
    movss xmm2, dword [r11]    ; factor

    mulss xmm1, xmm2
    divss xmm0, xmm1

    ret

section .data
earth_period: dd 31557600

mercury: dd 0.2408467
venus: dd 0.61519726
earth: dd 1.0
mars: dd 1.8808158
jupiter: dd 11.862615
saturn: dd 29.447498
uranus: dd 84.016846
neptune: dd 164.79132

factors: dq mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
factors_len equ $-factors