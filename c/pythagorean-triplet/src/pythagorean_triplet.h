#ifndef PYTHAGOREAN_TRIPLET
#define PYTHAGOREAN_TRIPLET

#include <stdint.h>
#include <stdbool.h>

typedef struct
{
    uint16_t a, b, c;
} triplet_t;

typedef struct
{
    uint16_t count;
    uint16_t cap;
    triplet_t *triplets;
} triplets_t;

int min(int x, int y);

int max(int x, int y);

int gcd(int x, int y);

triplets_t *make(uint16_t cap);

bool insert(triplets_t *triplets, triplet_t triplet);

bool grow(triplets_t *triplets);

triplets_t *triplets_with_sum(uint16_t sum);

void free_triplets(triplets_t *triplets);

#endif
