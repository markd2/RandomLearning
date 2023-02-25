#import "compiler.h"

#import <stdio.h>
#import <stdlib.h>

#import "common.h"
#import "scanner.h"

typedef struct Parser {
    Token current;
    Token previous;

    bool hadError;
    bool panicMode;
} Parser;

static Parser parser;
static Chunk *compilingChunk;


static void errorAt(Token *token, const char *message) {
    if (parser.panicMode) return;
    parser.panicMode = true;

    fprintf(stderr, "[line %d] Error", token->line);

    if (token->type == TOKEN_EOF) {
        fprintf(stderr, " at end");
    } else if (token->type == TOKEN_ERROR) {
        // nothing
    } else {
        fprintf(stderr, " at '%.*s'", token->length, token->start);
    }

    fprintf(stderr, ": %s\n", message);
    parser.hadError = true;
} // errorAt


static void errorAtCurrent(const char *message) {
    errorAt(&parser.current, message);
} // errorAtCurrent


static void error(const char *message) {
    errorAt(&parser.previous, message);
} // error


static void advance(void) {
    parser.previous = parser.current;

    while (true) {
        parser.current = scanToken();
        if (parser.current.type != TOKEN_ERROR) break;

        errorAtCurrent(parser.current.start);
    }
} // advance


static void consume(TokenType type, const char *message) {
    if (parser.current.type == type) {
        advance();
        return;
    }

    errorAtCurrent(message);
} // consume


static Chunk *currentChunk(void) {
    return compilingChunk;
} // currentChunk


static inline void emitByte(uint8_t byte) {
    writeChunk(currentChunk(), byte, parser.previous.line);
} // emitByte


static void emitBytes(uint8_t byte1, uint8_t byte2) {
    emitByte(byte1);
    emitByte(byte2);
} // emitByte


static void emitReturn() {
    emitByte(OP_RETURN);
} // emitReturn


static uint8_t makeConstant(Value value) {
    int constant = addConstant(currentChunk(), value);
    if (constant > UINT8_MAX) {
        error("Too many constants in one chunk");
        return 0;
    }
    return (uint8_t)constant;
} // makeConstant


static void grouping(void) {
    expression();
    consume(TOKEN_RIGHT_PAREN, "Expect ')' after expression");
} // grouping


static void endCompiler(void) {
    emitReturn();
} // endCompiler


static void emitConstant(Value value) {
    emitBytes(OP_CONSTANT, makeConstant(value));
} // emitConstant


static void number(void) {
    double value = strtod(parser.previous.start, NULL);
    emitConstant(value);
} // number


static void expression(void) {
} // expression

// --------------------------------------------------


bool compile(const char *source, Chunk *chunk) {
    initScanner(source);
    compilingChunk = chunk;

    parser.hadError = false;
    parser.panicMode = false;

    advance();
    expression();
    consume(TOKEN_EOF, "Expect end of expression");
    endCompiler();
    return !parser.hadError;
} // compile
