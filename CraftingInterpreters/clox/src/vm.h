#ifndef clox_vm_h
#define clox_vm_h

#include "common.h"
#include "chunk.h"

typedef enum InterpretResult {
    INTERPRET_OK,
    INTERPRET_COMPILE_ERROR,
    INTERPRET_RUNTIME_ERROR
} InterpretResult;

typedef struct VM {
    Chunk *chunk;
    uint8_t *ip;  // instruction about to be executed
} VM;

void initVM();
void freeVM();

InterpretResult interpret(Chunk *chunk);

#endif // clox_vm_h
