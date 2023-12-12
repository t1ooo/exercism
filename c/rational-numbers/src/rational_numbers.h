#ifndef RATIONAL_NUMBERS
#define RATIONAL_NUMBERS

#include <stdint.h>

typedef struct
{
    int numerator;
    int denominator;
} rational_t;

int gcd(int x, int y);
rational_t add(rational_t a, rational_t b);
rational_t subtract(rational_t a, rational_t b);
rational_t multiply(rational_t a, rational_t b);
rational_t divide(rational_t a, rational_t b);
rational_t absolute(rational_t a);
rational_t exp_rational(rational_t a, uint16_t n);
rational_t reduce(rational_t a);
float exp_real(uint16_t n, rational_t a);

#endif
