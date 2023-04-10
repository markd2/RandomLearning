#import "compiler.h"

#import <stdio.h>
#import <stdlib.h>

#import "common.h"
#import "scanner.h"

#if DEBUG_PRINT_CODE
#include "debug.h"
#endif

char *names[] = {
    [TOKEN_LEFT_PAREN] = "TOKEN_LEFT_PAREN",
    [TOKEN_RIGHT_PAREN] = "TOKEN_RIGHT_PAREN",
    [TOKEN_LEFT_BRACE] = "TOKEN_LEFT_BRACE",
    [TOKEN_RIGHT_BRACE] = "TOKEN_RIGHT_BRACE",
    [TOKEN_COMMA] = "TOKEN_COMMA",
    [TOKEN_DOT] = "TOKEN_DOT",
    [TOKEN_MINUS] = "TOKEN_MINUS",
    [TOKEN_PLUS] = "TOKEN_PLUS",
    [TOKEN_SEMICOLON] = "TOKEN_SEMICOLON",
    [TOKEN_SLASH] = "TOKEN_SLASH",
    [TOKEN_STAR] = "TOKEN_STAR",
    [TOKEN_BANG] = "TOKEN_BANG",
    [TOKEN_BANG_EQUAL] = "TOKEN_BANG_EQUAL",
    [TOKEN_EQUAL] = "TOKEN_EQUAL",
    [TOKEN_EQUAL_EQUAL] = "TOKEN_EQUAL_EQUAL",
    [TOKEN_GREATER] = "TOKEN_GREATER",
    [TOKEN_GREATER_EQUAL] = "TOKEN_GREATER_EQUAL",
    [TOKEN_LESS] = "TOKEN_LESS",
    [TOKEN_LESS_EQUAL] = "TOKEN_LESS_EQUAL",
    [TOKEN_IDENTIFIER] = "TOKEN_IDENTIFIER",
    [TOKEN_STRING] = "TOKEN_STRING",
    [TOKEN_NUMBER] = "TOKEN_NUMBER",
    [TOKEN_AND] = "TOKEN_AND",
    [TOKEN_CLASS] = "TOKEN_CLASS",
    [TOKEN_ELSE] = "TOKEN_ELSE",
    [TOKEN_FALSE] = "TOKEN_FALSE",
    [TOKEN_FOR] = "TOKEN_FOR",
    [TOKEN_FUN] = "TOKEN_FUN",
    [TOKEN_IF] = "TOKEN_IF",
    [TOKEN_NIL] = "TOKEN_NIL",
    [TOKEN_OR] = "TOKEN_OR",
    [TOKEN_PRINT] = "TOKEN_PRINT",
    [TOKEN_RETURN] = "TOKEN_RETURN",
    [TOKEN_SUPER] = "TOKEN_SUPER",
    [TOKEN_THIS] = "TOKEN_THIS",
    [TOKEN_TRUE] = "TOKEN_TRUE",
    [TOKEN_VAR] = "TOKEN_VAR",
    [TOKEN_WHILE] = "TOKEN_WHILE",
    [TOKEN_ERROR] = "TOKEN_ERROR",
    [TOKEN_EOF] = "TOKEN_EOF",
};

typedef struct Parser {
    Token current;
    Token previous;

    bool hadError;
    bool panicMode;
} Parser;

typedef enum Precedence {
    // lowest to highest
    PREC_NONE,
    PREC_ASSIGNMENT, // =
    PREC_OR,         // or
    PREC_AND,        // and
    PREC_EQUALITY,   // == !=
    PREC_COMPARISON, // < > <= >=
    PREC_TERM,       // + -
    PREC_FACTOR,     // * /
    PREC_UNARY,      // - !
    PREC_CALL,       // . ()
    PREC_PRIMARY
} Precedence;

typedef void (*ParseFn)();

typedef struct ParseRule {
    ParseFn prefix;
    ParseFn infix;
    Precedence precedence;
} ParseRule;

static Parser parser;
static Chunk *compilingChunk;

static void parsePrecedence(Precedence precedence);
static ParseRule *getRule(TokenType type);

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
        printf("advance current to %d %s\n", parser.current.type, names[parser.current.type]);
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


static void expression(void) {
    parsePrecedence(PREC_ASSIGNMENT);
} // expression


static void unary(void) {
    TokenType operatorType = parser.previous.type;

    parsePrecedence(PREC_UNARY);

    switch (operatorType) {
    case TOKEN_MINUS: emitByte(OP_NEGATE); break;
    default: return;
    }

} // unary

// Start at the current toke and parse any expression at the given level or higher
static void parsePrecedence(Precedence precedence) {
    advance();

    ParseFn prefixRule = getRule(parser.previous.type)->prefix;
    if (prefixRule == NULL) {
        error("expect expression");
        printf("expect expression (rule %d)\n", parser.previous.type);
        return;
    }
    prefixRule(); // consumes whatever other tokens it needs

    while (precedence <= getRule(parser.current.type)->precedence) {
        advance();
        ParseFn infixRule = getRule(parser.current.type)->infix;
//        if (infixRule == NULL) {
//            error("expect expression (infix)");
//            continue;
//        }
        infixRule();
    }
} // parsePrecedence

static void grouping(void) {
    expression();
    consume(TOKEN_RIGHT_PAREN, "Expect ')' after expression");
} // grouping


static void endCompiler(void) {
    emitReturn();
#if DEBUG_PRINT_CODE
    if (!parser.hadError) {
        disassembleChunk(currentChunk(), "code");
    }
#endif
} // endCompiler

static void binary() {
    TokenType operatorType = parser.previous.type;
    ParseRule *rule = getRule(operatorType);

    // when we get here, the left hand has been parsed. This parses the
    // the right hand. Then emit the op to combine them.
    parsePrecedence((Precedence)(rule->precedence + 1));

    switch (operatorType) {
    case TOKEN_PLUS: emitByte(OP_ADD); break;
    case TOKEN_MINUS: emitByte(OP_SUBTRACT); break;
    case TOKEN_STAR: emitByte(OP_MULTIPLY); break;
    case TOKEN_SLASH: emitByte(OP_DIVIDE); break;
    default:
        return; // unreachable
    }
} // binary


static void emitConstant(Value value) {
    emitBytes(OP_CONSTANT, makeConstant(value));
} // emitConstant


static void number(void) {
    double value = strtod(parser.previous.start, NULL);
    emitConstant(value);
} // number


ParseRule rules[] = {
    [TOKEN_LEFT_PAREN]	= { grouping, 	NULL,	PREC_NONE },
    [TOKEN_RIGHT_PAREN]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_LEFT_BRACE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_RIGHT_BRACE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_COMMA]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_DOT]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_MINUS]	= { unary, 	binary,	PREC_TERM },
    [TOKEN_PLUS]	= { NULL, 	binary,	PREC_TERM },
    [TOKEN_SEMICOLON]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_SLASH]	= { NULL, 	binary,	PREC_FACTOR },
    [TOKEN_STAR]	= { NULL, 	binary,	PREC_FACTOR },
    [TOKEN_BANG]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_BANG_EQUAL]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_EQUAL]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_EQUAL_EQUAL]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_GREATER]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_GREATER_EQUAL]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_LESS]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_LESS_EQUAL]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_IDENTIFIER]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_STRING]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_NUMBER]	= { number, 	NULL,	PREC_NONE },
    [TOKEN_AND]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_CLASS]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_ELSE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_FALSE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_FOR]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_FUN]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_IF]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_NIL]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_OR]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_PRINT]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_RETURN]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_SUPER]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_THIS]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_TRUE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_VAR]		= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_WHILE]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_ERROR]	= { NULL, 	NULL,	PREC_NONE },
    [TOKEN_EOF]		= { NULL, 	NULL,	PREC_NONE }
};

static ParseRule *getRule(TokenType type) {
    printf("GETTING RULE FOR %d %s\n", type, names[type]);
    return &rules[type];
} // getRule


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
