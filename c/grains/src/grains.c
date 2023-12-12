#include "grains.h"

uint64_t square(uint8_t index)
{
    return (1 <= index && index <= 64)
               ? UINT64_C(1) << (index - 1) // 2^(index-1)
               : 0;
}

uint64_t total(void)
{
    return UINT64_MAX; // (2^64)-1
}