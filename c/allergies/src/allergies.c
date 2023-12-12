#include "allergies.h"
#include <string.h>

bool is_allergic_to(allergen_t allergen, int score)
{
    return ((1 << allergen) & score) != 0;
}

allergen_list_t get_allergens(int score)
{
    allergen_list_t list;
    list.count = 0;
    memset(list.allergens, false, sizeof(list.allergens));

    for (int i = 0; i < ALLERGEN_COUNT; i++) {
        if (is_allergic_to(i, score)) {
            list.allergens[i] = true;
            list.count++;
        }
    }

    return list;
}
