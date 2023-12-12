#include "isogram.h"
#include <stdlib.h>

bool is_isogram(const char phrase[])
{
    if (phrase == NULL)
    {
        return false;
    }

    unsigned long int bitmask = 0;

    for (; *phrase; phrase++)
    {
        unsigned char ch = *phrase;

        // to uppercase
        if ('a' <= ch)
        {
            ch -= 'a' - 'A';
        }

        // continue if not alpha char
        if (ch < 'A' || 'Z' < ch)
        {
            continue;
        }

        // A to 0, B to 1, ...
        ch -= 'A';

        unsigned long int flag = 1UL << ch;
        // return false if bitmask already contains char flag
        if (bitmask & flag)
        {
            return false;
        }

        // set char flag to bitmask
        bitmask |= flag;
    }

    return true;
}
