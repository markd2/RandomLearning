#include "value.h"

#include <stdlib.h>
#include <stdio.h>

#include "memory.h"

void initValueArray(ValueArray *array) {
    array->count = 0;
    array->capacity = 0;
    array->values = NULL;
} // initValueArray


void freeValueArray(ValueArray *array) {
    FREE_ARRAY(uint8_t, array->values, array->capacity);
    initValueArray(array);
} // freeValueArray


void writeValueArray(ValueArray *array, Value value) {
    if (array->capacity < array->count + 1) {
        int oldCapacity = array->capacity;
        array->capacity = GROW_CAPACITY(oldCapacity);
        array->values = GROW_ARRAY(Value, array->values,
                                   oldCapacity, array->capacity);
    }
    array->values[array->count] = value;
    array->count++;

} // writeValueArray


void printValue(Value value) {
    printf("%g", value);
} // printValue
