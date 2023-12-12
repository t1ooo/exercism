#include "hamming.h"

int compute(const char *a, const char *b)
{
    if (!a || !b)
    {
        return -1;
    }

    int distance = 0;

    int i = 0;
    for (; a[i] && b[i]; i++)
    {
        distance += (a[i] == b[i]) ? 0 : 1;
    }

    return (a[i] || b[i]) ? -1 : distance;
}