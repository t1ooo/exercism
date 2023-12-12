#include "armstrong_numbers.h"
#include <math.h>

bool is_armstrong_number(int candidate)
{
    int len = floor(log10(candidate)) + 1;
    int sum = 0;
    int c = candidate;

    while (0 < c)
    {
        sum += pow(c % 10, len);
        c = c / 10;
    }

    return sum == candidate;
}