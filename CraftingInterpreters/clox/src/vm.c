#import "vm.h"

#import <stdio.h>

#import "chunk.h"
#import "debug.h"
#import "value.h"


// TODO: this is static for the book.  IRL would pass this around.
VM vm;

static void resetStack() {
    vm.stackTop = vm.stack;
} // resetStack


void initVM() {
    resetStack();
} // initVM


void freeVM() {
} // freeVM


static InterpretResult run() {
    #define READ_BYTE() (*vm.ip++)
    #define READ_CONSTANT() (vm.chunk->constants.values[READ_BYTE()])
    
    while (true) {
#if DEBUG_TRACE_EXECUTION
        printf("            ");
        for (Value *slot = vm.stack; slot < vm.stackTop; slot++) {
            printf("[");
            printValue(*slot);
            printf("]");
        }
        printf("\n");
        disassembleInstruction(vm.chunk,
                               (int)(vm.ip - vm.chunk->code));
#endif
        uint8_t instruction;
        switch (instruction = READ_BYTE()) {
            case OP_CONSTANT: {
                Value constant = READ_CONSTANT();
                push(constant);

                break;
            }
            case OP_RETURN: {
                printValue(pop());
                printf("\n");
                return INTERPRET_OK;
            }
        }
    }
    #undef READ_CONSTANT
    #undef READ_BYTE
} // run


InterpretResult interpret(Chunk *chunk) {
    vm.chunk = chunk;
    vm.ip = vm.chunk->code;
    return run();
} // interpret


void push(Value value) {
    *vm.stackTop = value;
    vm.stackTop++;
} // push


Value pop(void) {
    vm.stackTop--;
    return *vm.stackTop;
} // pop





