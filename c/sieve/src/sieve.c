#include "sieve.h"
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

uint32_t sieve(uint32_t limit, uint32_t *primes, size_t max_primes)
{
    size_t len = limit + 1;
    bool *nums = malloc(len * sizeof(bool));
    if (nums == NULL) {
        return 0;
    }

    memset(nums, true, sizeof(bool) * len);
    nums[0] = false;
    nums[1] = false;

    for (size_t p = 2; p * p < len; p++) {
        if (nums[p]) {
            for (size_t i = p * p; i < len; i += p) {
                nums[i] = false;
            }
        }
    }

    uint32_t count = 0;
    for (uint32_t p = 2; p < len && count < max_primes; p++) {
        if (nums[p]) {
            primes[count++] = p;
        }
    }

    free(nums);

    return count;
}
