#include "debug.h"

#include <stdio.h>

static int simpleInstruction(const char *name, int offset);

void disassembleChunk(Chunk *chunk, const char *name) {
    printf("== %s ==\n", name);
    
    for (int offset = 0; offset < chunk->count; /**/) {
        offset = disassembleInstruction(chunk, offset);
    }
} // disassembleChunk


int disassembleInstruction(Chunk *chunk, int offset) {
    printf("%04d ", offset);

    uint8_t instruction = chunk->code[offset];

    switch(instruction) {
    case OP_RETURN:
        return simpleInstruction("OP_RETURN", offset);
    default:
        printf("Unknown opcode %d\n", instruction);
        return offset + 1;
    }
} // dissassembleInstruction


static int simpleInstruction(const char *name, int offset) {
    printf("%s\n", name);
    return offset + 1;
} // simpleInstruction

