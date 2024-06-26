#ifndef clox_value_h
#define clox_value_h

#include "common.h"

typedef double Value;

typedef struct ValueArray {
    int capacity;
    int count;
    Value *values;
} ValueArray;

void initValueArray(ValueArray *valueArray);
void freeValueArray(ValueArray *valueArray); // also clears freed ValueArray structure
void writeValueArray(ValueArray *valueArray, Value value);

void printValue(Value value);


#endif // clox_value_h
