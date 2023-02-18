#ifndef clox_value_h
#define clox_value_h

#include "common.h"

typedef double Value;

typedef struct ValueArray {
    int capacity;
    int count;
    Value *values;
} ValueArray;

void initValueArray(ValueArray *value);
void freeValueArray(ValueArray *value); // also clears freed ValueArray structure
void writeValueArray(ValueArray *value, uint8_t byte);


#endif // clox_value_h
