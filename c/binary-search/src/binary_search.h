#ifndef BINARY_SEARCH_H
#define BINARY_SEARCH_H

#include <stddef.h>

const int *search(int value, const int *arr, int left, int right);
const int *binary_search(int value, const int *arr, size_t length);

#endif
