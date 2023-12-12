#include "resistor_color.h"
#include "stdbool.h"

int color_code(resistor_band_t code)
{
    return code;
}

bool init = false;

resistor_band_t *colors()
{
    static resistor_band_t res[WHITE + 1];
    if (!init)
    {
        for (resistor_band_t i = BLACK; i <= WHITE; i++)
        {
            res[i] = i;
        }
    }
    init = true;
    return res;
}