#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stdlib.h>
#include <stdbool.h>

typedef int list_value_t;

typedef struct
{
   size_t length;
   list_value_t values[];
} list_t;

list_t *make_list(size_t length);

list_t *new_list(size_t length, list_value_t values[]);

void append_value(list_t *list, list_value_t value);

void append_values(list_t *list, size_t length, list_value_t values[]);

list_t *append_list(list_t *list1, list_t *list2);

list_t *filter_list(list_t *list, bool (*filter)(list_value_t value));

size_t length_list(list_t *list);

list_t *map_list(list_t *list, list_value_t (*map)(list_value_t value));

list_value_t foldl_list(list_t *list, list_value_t initial,
                        list_value_t (*foldl)(list_value_t value,
                                              list_value_t initial));

list_value_t foldr_list(list_t *list, list_value_t initial,
                        list_value_t (*foldr)(list_value_t value,
                                              list_value_t initial));

list_t *reverse_list(list_t *list);

void delete_list(list_t *list);

#endif
