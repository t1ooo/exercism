#include "phone_number.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define NUMBER_LENGTH 10

char *phone_number_clean(const char *input)
{
    size_t len = strlen(input) > NUMBER_LENGTH
                     ? strlen(input)
                     : NUMBER_LENGTH;
    char *ret = malloc((len + 1) * sizeof(char));

    int k = 0;
    for (size_t i = 0; i < strlen(input); i++) {
        // must contain only digits
        if (isalpha(input[i])) {
            goto error;
        }

        // collect digits
        if (isdigit(input[i])) {
            ret[k] = input[i];
            k++;
        }
    }
    ret[k] = '\0';

    // remove the country code if present
    if (1 <= strlen(ret) && ret[0] == '1') {
        memmove(ret, ret + 1, strlen(ret));
    }

    // length must be equal NUMBER_LENGTH
    if (strlen(ret) != NUMBER_LENGTH) {
        goto error;
    }

    // the area code must start with [2-9]
    if (ret[0] == '0' || ret[0] == '1') {
        goto error;
    }

    // the exchange code must start with [2-9]
    if (ret[3] == '0' || ret[3] == '1') {
        goto error;
    }

    return ret;

error:
    strcpy(ret, "0000000000");
    return ret;
}
