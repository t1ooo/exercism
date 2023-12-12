#include "square_root.h"

// babylonian method
int square_root(unsigned int number)
{
    if (number == 0)
    {
        return number;
    }

    int prev_root = number;
    int root = number;
    do
    {
        prev_root = root;
        root = (root + (number / root)) / 2;
    } while (prev_root != root);

    return root;
}
