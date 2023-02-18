#ifndef clox_chunk_h
#define clox_chunk_h

#include "common.h"

// Love ya, Chunks!

typedef enum OpCode {
    OP_RETURN
} OpCode;

typedef struct Chunk {
    int capacity;
    int count;
    uint8_t *code;
} Chunk;

void initChunk(Chunk *chunk);
void freeChunk(Chunk *chunk); // also clears freed Chunk structure
void writeChunk(Chunk *chunk, uint8_t byte);


#endif // clox_chunk_h

