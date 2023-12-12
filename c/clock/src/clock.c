#include "clock.h"
#include <stdio.h>
#include <string.h>

static void minutes_to_text(char *out, int minutes)
{
    int day = (24 * 60);
    minutes = ((minutes % day) + day) % day;
    sprintf(out, "%02d:%02d", minutes / 60, minutes % 60);
}

static int text_to_minutes(char *text)
{
    int hours = 0;
    int minutes = 0;
    sscanf(text, "%d:%d", &hours, &minutes);
    return (hours * 60) + minutes;
}

clock_t clock_create(int hours, int minutes)
{
    clock_t clock;
    minutes = (hours * 60) + minutes;
    minutes_to_text(clock.text, minutes);
    return clock;
}

clock_t clock_add(clock_t clock_in, int minutes_add)
{
    int minutes = text_to_minutes(clock_in.text) + minutes_add;
    return clock_create(0, minutes);
}

clock_t clock_subtract(clock_t clock, int minutes_subtract)
{
    return clock_add(clock, -minutes_subtract);
}

bool clock_is_equal(clock_t a, clock_t b)
{
    return strcmp(a.text, b.text) == 0;
}
