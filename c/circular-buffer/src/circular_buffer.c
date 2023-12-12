#include "circular_buffer.h"
#include <errno.h>

circular_buffer_t *new_circular_buffer(size_t capacity)
{
    if (capacity == 0) {
        return NULL;
    }

    circular_buffer_t *buffer = malloc(sizeof(circular_buffer_t));
    if (buffer == NULL) {
        return NULL;
    }

    buffer->values = calloc(capacity, sizeof(buffer_value_t));
    if (buffer->values == NULL) {
        free(buffer);
        return NULL;
    }

    buffer->capacity = capacity;
    clear_buffer(buffer);

    return buffer;
}

int16_t write(circular_buffer_t *buffer, buffer_value_t value)
{
    if (buffer->length == buffer->capacity) {
        errno = ENOBUFS;
        return EXIT_FAILURE;
    }

    buffer->values[buffer->write_index] = value;
    buffer->write_index = (buffer->write_index + 1) % buffer->capacity;
    buffer->length++;

    return EXIT_SUCCESS;
}

int16_t overwrite(circular_buffer_t *buffer, buffer_value_t value)
{
    if (write(buffer, value) == EXIT_SUCCESS) {
        return EXIT_SUCCESS;
    }

    errno = 0;
    buffer_value_t drop;
    read(buffer, &drop);

    return write(buffer, value);
}

int16_t read(circular_buffer_t *buffer, buffer_value_t *read_value)
{
    if (buffer->length == 0) {
        errno = ENODATA;
        return EXIT_FAILURE;
    }

    *read_value = buffer->values[buffer->read_index];
    buffer->read_index = (buffer->read_index + 1) % buffer->capacity;
    buffer->length--;

    return EXIT_SUCCESS;
}

void clear_buffer(circular_buffer_t *buffer)
{
    buffer->length = 0;
    buffer->read_index = 0;
    buffer->write_index = 0;
}

void delete_buffer(circular_buffer_t *buffer)
{
    free(buffer->values);
    free(buffer);
}
