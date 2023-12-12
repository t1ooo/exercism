#include "saddle_points.h"
#include <stdlib.h>

static size_t min(size_t x, size_t y) { return x < y ? x : y; }
static size_t max(size_t x, size_t y) { return x > y ? x : y; }

static uint8_t maximum(size_t len, uint8_t array[len])
{
    uint8_t val = array[0];
    for (size_t i = 1; i < len; i++) {
        val = max(val, array[i]);
    }
    return val;
}

static uint8_t minimum(size_t len, uint8_t array[len])
{
    uint8_t val = array[0];
    for (size_t i = 1; i < len; i++) {
        val = min(val, array[i]);
    }
    return val;
}

static void transpose(
    size_t nrows,
    size_t ncols,
    uint8_t matrix[nrows][ncols],
    uint8_t out[ncols][nrows])
{
    for (size_t r = 0; r < nrows; r++) {
        for (size_t c = 0; c < ncols; c++) {
            out[c][r] = matrix[r][c];
        }
    }
}

saddle_points_t *saddle_points(
    size_t nrows,
    size_t ncols,
    uint8_t matrix[nrows][ncols])
{
    size_t count = max(nrows, ncols);
    saddle_points_t *points = malloc(
        sizeof(saddle_points_t)
        + sizeof(saddle_point_t) * count);
    points->count = 0;

    if (nrows == 0 || ncols == 0 || matrix == NULL) {
        return points;
    }

    uint8_t max_of_rows[nrows];
    for (size_t r = 0; r < nrows; r++) {
        max_of_rows[r] = maximum(ncols, matrix[r]);
    }

    uint8_t t_matrix[ncols][nrows];
    transpose(nrows, ncols, matrix, t_matrix);

    uint8_t min_of_cols[ncols];
    for (size_t c = 0; c < ncols; c++) {
        min_of_cols[c] = minimum(nrows, t_matrix[c]);
    }

    for (size_t r = 0; r < nrows; r++) {
        for (size_t c = 0; c < ncols; c++) {
            if (max_of_rows[r] == min_of_cols[c]) {
                saddle_point_t point = {r + 1, c + 1};
                points->points[points->count] = point;
                points->count++;
            }
        }
    }

    return points;
}

void free_saddle_points(saddle_points_t *points)
{
    free(points);
}
