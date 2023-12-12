#include "pythagorean_triplet.h"
#include <stdlib.h>
#include <stddef.h>
#include <math.h>

int min(int x, int y) { return x < y ? x : y; }
int max(int x, int y) { return x > y ? x : y; }

int gcd(int x, int y)
{
    x = abs(x);
    y = abs(y);
    int rem;
    while (y != 0) {
        rem = x % y;
        x = y;
        y = rem;
    }
    return x;
}

triplets_t *make(uint16_t cap)
{
    triplets_t *triplets = malloc(sizeof(triplets_t));
    if (triplets == NULL) {
        return NULL;
    }

    triplets->triplets = malloc(sizeof(triplet_t) * cap);
    if (triplets->triplets == NULL) {
        free(triplets);
        return NULL;
    }

    triplets->count = 0;
    triplets->cap = cap;
    return triplets;
}

bool grow(triplets_t *triplets)
{
    uint16_t new_cap = triplets->cap * 2;
    if (new_cap == 0) {
        new_cap = 1;
    }

    triplet_t *new_triplets = realloc(triplets->triplets, sizeof(triplet_t) * new_cap);
    if (new_triplets == NULL) {
        return false;
    }

    triplets->triplets = new_triplets;
    triplets->cap = new_cap;
    return true;
}

bool insert(triplets_t *triplets, triplet_t triplet)
{
    if (triplets->count == triplets->cap) {
        if (!grow(triplets)) {
            return false;
        }
    }
    triplets->triplets[triplets->count] = triplet;
    triplets->count++;
    return true;
}

triplets_t *triplets_with_sum(uint16_t sum)
{
    triplets_t *triplets = make(0);
    if (triplets == NULL) {
        return NULL;
    }

    int a, b, c;
    for (int m = 2; m < sqrt(sum); m++) {
        for (int n = (m % 2) + 1; n < m; n += 2) {
            if (gcd(m, n) != 1) {
                continue;
            }

            float k = (float)sum / (2 * m * n + 2 * m * m);
            if (ceil(k) != k) {
                continue;
            }

            a = k * (m * m - n * n);
            b = k * (2 * m * n);
            c = k * (m * m + n * n);

            triplet_t triplet = {min(a, b), max(a, b), c};
            if (!insert(triplets, triplet)) {
                free(triplets);
                return NULL;
            }
        }
    }

    return triplets;
}

void free_triplets(triplets_t *triplets)
{
    free(triplets->triplets);
    free(triplets);
}
