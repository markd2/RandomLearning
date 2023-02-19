#include "common.h"

#include <stdio.h>

#include "chunk.h"
#include "debug.h"
#include "vm.h"

int main(int argc, const char* argv[]) {
    initVM();

    Chunk chunk;
    initChunk(&chunk);

    int constant = addConstant(&chunk, 1.2);

    writeChunk(&chunk, OP_CONSTANT, __LINE__);
    writeChunk(&chunk, constant, __LINE__);

    constant = addConstant(&chunk, 3.4);
    writeChunk(&chunk, OP_CONSTANT, __LINE__);
    writeChunk(&chunk, constant, __LINE__);

    writeChunk(&chunk, OP_ADD, __LINE__);

    constant = addConstant(&chunk, 5.6);
    writeChunk(&chunk, OP_CONSTANT, __LINE__);
    writeChunk(&chunk, constant, __LINE__);

    writeChunk(&chunk, OP_ADD, __LINE__);
    writeChunk(&chunk, OP_NEGATE, __LINE__);

    writeChunk(&chunk, OP_RETURN, __LINE__);

    interpret(&chunk);

    disassembleChunk(&chunk, "All the things");

    freeChunk(&chunk);
    freeVM();
    return 0;
}
