#ifndef CLOCK_H
#define CLOCK_H

#include <stdbool.h>

#define MAX_STR_LEN (5 + 1) // "##:##\0"

typedef struct
{
   char text[MAX_STR_LEN];
} clock_t;

clock_t clock_create(int hours, int minutes);
clock_t clock_add(clock_t clock, int minutes_add);
clock_t clock_subtract(clock_t clock, int minutes_subtract);
bool clock_is_equal(clock_t a, clock_t b);

#endif
