#ifndef clox_vm_h
#define clox_vm_h

#import "chunk.h"
#import "common.h"
#import "value.h"

static const int STACK_MAX = 256;

typedef enum InterpretResult {
    INTERPRET_OK,
    INTERPRET_COMPILE_ERROR,
    INTERPRET_RUNTIME_ERROR
} InterpretResult;

typedef struct VM {
    Chunk *chunk;
    uint8_t *ip;  // instruction about to be executed
    Value stack[STACK_MAX];
    Value *stackTop;
} VM;

void initVM();
void freeVM();

InterpretResult interpret(Chunk *chunk);
void push(Value value);
Value pop(void);

#endif // clox_vm_h
