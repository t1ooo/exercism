#include "rational_numbers.h"
#include <stdlib.h>
#include <math.h>

// greatest common divisor
int gcd(int x, int y)
{
    return (y == 0) ? x : gcd(y, x % y);
}

rational_t reduce(rational_t a)
{
    int divisor = gcd(a.numerator, a.denominator);
    int numerator = a.numerator / divisor;
    int denominator = a.denominator / divisor;

    // fix minus signs: 1/(-2) -> (-1)/2
    if (denominator < 0) {
        numerator = -numerator;
        denominator = -denominator;
    }

    return (rational_t){numerator, denominator};
}

rational_t add(rational_t a, rational_t b)
{
    return reduce((rational_t){
        (a.numerator * b.denominator + b.numerator * a.denominator),
        (a.denominator * b.denominator),
    });
}

rational_t subtract(rational_t a, rational_t b)
{
    return reduce((rational_t){
        (a.numerator * b.denominator - b.numerator * a.denominator),
        (a.denominator * b.denominator),
    });
}

rational_t multiply(rational_t a, rational_t b)
{
    return reduce((rational_t){
        (a.numerator * b.numerator),
        (a.denominator * b.denominator),
    });
}

rational_t divide(rational_t a, rational_t b)
{
    return reduce((rational_t){
        (a.numerator * b.denominator),
        (b.numerator * a.denominator),
    });
}

rational_t absolute(rational_t a)
{
    return (rational_t){
        abs(a.numerator),
        abs(a.denominator),
    };
}

rational_t exp_rational(rational_t a, uint16_t n)
{
    return ((rational_t){
        pow((float)a.numerator, n),
        pow((float)a.denominator, n),
    });
}

float exp_real(uint16_t x, rational_t a)
{
    return pow(x, (float)a.numerator / a.denominator);
}

