#include "pascals_triangle.h"
#include <stdlib.h>

void free_triangle(uint8_t **triangle, size_t rows)
{
    for (size_t i = 0; i < rows; i++) {
        free(triangle[i]);
    }
    free(triangle);
}

static uint8_t **alloc_triangle(size_t rows)
{
    rows = rows > 0 ? rows : 1;
    uint8_t **triangle = malloc(rows * sizeof(uint8_t *));

    for (size_t i = 0; i < rows; i++) {
        triangle[i] = calloc(rows, sizeof(uint8_t));
        if (triangle[i] == NULL) {
            free_triangle(triangle, i);
            return NULL;
        }
    }

    return triangle;
}

uint8_t **create_triangle(size_t rows)
{
    uint8_t **triangle = alloc_triangle(rows);
    if (triangle == NULL || rows == 0) {
        return triangle;
    }

    for (size_t i = 0; i < rows; i++) {
        triangle[i][0] = 1;
        triangle[i][i] = 1;
        for (size_t j = 1; j < i; j++) {
            triangle[i][j] = triangle[i - 1][j - 1] + triangle[i - 1][j];
        }
    }

    return triangle;
}
