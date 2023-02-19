#import "vm.h"

#import <stdio.h>

// TODO: this is static for the book.  IRL would pass this around.
VM vm;

void initVM() {
} // initVM


void freeVM() {
} // freeVM


static InterpretResult run() {
    #define READ_BYTE() (*vm.ip++)
    #define READ_CONSTANT() (vm.chunk->constants.values[READ_BYTE()])
    
    while (true) {
        uint8_t instruction;
        switch (instruction = READ_BYTE()) {
            case OP_CONSTANT: {
                Value constant = READ_CONSTANT();
                printValue(constant);
                printf("\n");
                break;
            }
            case OP_RETURN: return INTERPRET_OK;
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





