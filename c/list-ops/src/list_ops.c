#include "list_ops.h"
#include <string.h>

list_t *make_list(size_t length)
{
    list_t *ret_list = malloc(sizeof(list_t) + length * sizeof(list_value_t));
    if (ret_list == NULL) {
        return NULL;
    }

    ret_list->length = 0;
    
    return ret_list;
}

list_t *new_list(size_t length, list_value_t values[])
{
    list_t *ret_list = make_list(length);
    if (ret_list == NULL) {
        return NULL;
    }

    append_values(ret_list, length, values);
    
    return ret_list;
}

void append_value(list_t *list, list_value_t value)
{
    list->values[list->length] = value;
    list->length++;
}

void append_values(list_t *list, size_t length, list_value_t values[])
{
    memcpy(list->values + list->length, values, length * sizeof(list_value_t));
    list->length += length;
}

list_t *append_list(list_t *list1, list_t *list2)
{
    list_t *ret_list = make_list(list1->length + list2->length);
    if (ret_list == NULL) {
        return NULL;
    }

    append_values(ret_list, list1->length, list1->values);
    append_values(ret_list, list2->length, list2->values);
    
    return ret_list;
}

list_t *filter_list(list_t *list, bool (*filter)(list_value_t value))
{
    list_t *ret_list = make_list(list->length);
    if (ret_list == NULL) {
        return NULL;
    }

    for (int i = 0; i < (int)list->length; i++) {
        if (filter(list->values[i])) {
            append_value(ret_list, list->values[i]);
        }
    }
    
    return ret_list;
}

size_t length_list(list_t *list)
{
    return list->length;
}

list_t *map_list(list_t *list, list_value_t (*map)(list_value_t value))
{
    list_t *ret_list = make_list(list->length);
    if (ret_list == NULL) {
        return NULL;
    }

    for (int i = 0; i < (int)list->length; i++) {
        append_value(ret_list, map(list->values[i]));
    }
    
    return ret_list;
}

list_value_t foldl_list(list_t *list, list_value_t initial,
                        list_value_t (*foldl)(list_value_t value,
                                              list_value_t initial))
{
    for (int i = 0; i < (int)list->length; i++) {
        initial = foldl(list->values[i], initial);
    }
    
    return initial;
}

list_value_t foldr_list(list_t *list, list_value_t initial,
                        list_value_t (*foldr)(list_value_t value,
                                              list_value_t initial))
{
    for (int i = (int)list->length - 1; i >= 0; i--) {
        initial = foldr(list->values[i], initial);
    }
    
    return initial;
}

list_t *reverse_list(list_t *list)
{
    list_t *ret_list = make_list(list->length);
    if (ret_list == NULL) {
        return NULL;
    }

    for (int i = (int)list->length - 1; i >= 0; i--) {
        append_value(ret_list, list->values[i]);
    }
    
    return ret_list;
}

void delete_list(list_t *list)
{
    free(list);
}
