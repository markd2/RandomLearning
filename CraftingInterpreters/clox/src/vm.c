#import "vm.h"

#import <stdio.h>

#import "chunk.h"
#import "compiler.h"
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
    #define BINARY_OP(op)                           \
        do {                                        \
            double b = pop();                       \
            double a = pop();                       \
            push(a op b);                           \
        } while(false)
    
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
        case OP_ADD:       BINARY_OP(+); break;
        case OP_SUBTRACT:  BINARY_OP(-); break;
        case OP_MULTIPLY:  BINARY_OP(*); break;
        case OP_DIVIDE:    BINARY_OP(/); break;

        case OP_NEGATE: push(-pop()); break;

        case OP_RETURN: {
            printValue(pop());
            printf("\n");
            return INTERPRET_OK;
        }
        }
    }

    #undef BINARY_OP
    #undef READ_CONSTANT
    #undef READ_BYTE
} // run


InterpretResult interpret(const char *source) {
    Chunk chunk;
    initChunk(&chunk);

    if (!compile(source, &chunk)) {
        freeChunk(&chunk);
        return INTERPRET_COMPILE_ERROR;
    }

    vm.chunk = &chunk;
    vm.ip = vm.chunk->code;
    
    InterpretResult result = run();

    freeChunk(&chunk);
    return result;
} // interpret


void push(Value value) {
    *vm.stackTop = value;
    vm.stackTop++;
} // push


Value pop(void) {
    vm.stackTop--;
    return *vm.stackTop;
} // pop





