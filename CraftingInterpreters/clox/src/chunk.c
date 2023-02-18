#include "chunk.h"

#include <stdlib.h>
#include "memory.h"

void initChunk(Chunk *chunk) {
    chunk->count = 0;
    chunk->capacity = 0;
    chunk->code = NULL;
    initValueArray(&chunk->constants);
} // initChunk


void freeChunk(Chunk *chunk) {
    freeValueArray(&chunk->constants);
    FREE_ARRAY(uint8_t, chunk->code, chunk->capacity);
    initChunk(chunk);
} // freeChunk


void writeChunk(Chunk *chunk, uint8_t byte) {
    if (chunk->capacity < chunk->count + 1) {
        int oldCapacity = chunk->capacity;
        chunk->capacity = GROW_CAPACITY(oldCapacity);
        chunk->code = GROW_ARRAY(uint8_t, chunk->code,
                                 oldCapacity, chunk->capacity);
    }
    chunk->code[chunk->count] = byte;
    chunk->count++;

} // writeChunk


int addConstant(Chunk *chunk, Value value) {
    writeValueArray(&chunk->constants, value);
    return chunk->constants.count - 1;
} // addConstant

