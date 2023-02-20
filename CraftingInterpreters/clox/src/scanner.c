#include <stdio.h>
#include <string.h>

#import "common.h"
#import "scanner.h"

typedef struct Scanner {
    const char *start;
    const char *current;
    int line;
} Scanner;

Scanner scanner;

void initScanner(const char *source) {
    scanner.start = source;
    scanner.current = source;
    scanner.line = 1;
} // initScanner


static bool isAtEnd(void) {
    return *scanner.current == '\0';
} // isAtEnd


static Token makeToken(TokenType type) {
    Token token;

    token.type = type;
    token.start = scanner.start;
    token.length = (int)(scanner.current - scanner.start);
    token.line = scanner.line;

    return token;
} // makeToken


static Token errorToken(const char *message) {
    Token token;

    token.type = TOKEN_ERROR;
    token.start = message;
    token.length = strlen(message);
    token.line = scanner.line;

    return token;

} // errorToken


Token scanToken(void) {
    scanner.start = scanner.current;
    if (isAtEnd()) return makeToken(TOKEN_EOF);
    
    return errorToken("Unexpected character");
} // scanToken

