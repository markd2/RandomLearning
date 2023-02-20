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

bool compile(const char *source, Chunk *chunk) {
    initScanner(source);

    parser.hadError = false;
    parser.panicMode = false;

    advance();
    expression();
    consume(TOKEN_EOF, "Expect end of expression");
    return !parser.hadError;
} // compile
