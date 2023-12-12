#include "binary_search.h"

const int *search(int value, const int *arr, int left, int right)
{
    if (right < left) {
        return NULL;
    }

    size_t index = (left + right) / 2;
    int middle = arr[index];

    if (value == middle) {
        return &arr[index];
    }
    if (value < middle) {
        return search(value, arr, left, index - 1);
    }
    return search(value, arr, index + 1, right);
}

const int *binary_search(int value, const int *arr, size_t length)
{
    if (arr == NULL || length == 0) {
        return NULL;
    }
    return search(value, arr, 0, length - 1);
}
