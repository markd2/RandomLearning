#ifndef clox_scanner_h
#define clox_scanner_h

typedef enum TokenType {
    // single-character tokens
    TOKEN_LEFT_PAREN, TOKEN_RIGHT_PAREN,
    TOKEN_LEFT_BRACE, TOKEN_RIGHT_BRACE,
    TOKEN_COMMA, TOKEN_DOT, TOKEN_MINUS, TOKEN_PLUS,
    TOKEN_SEMICOLON, TOKEN_SLASH, TOKEN_STAR, // 10

    // one or two character tokens
    TOKEN_BANG, TOKEN_BANG_EQUAL,
    TOKEN_EQUAL, TOKEN_EQUAL_EQUAL,
    TOKEN_GREATER, TOKEN_GREATER_EQUAL,
    TOKEN_LESS, TOKEN_LESS_EQUAL, // 18

    // literals
    TOKEN_IDENTIFIER, TOKEN_STRING, TOKEN_NUMBER, // 21

    // keywords
    TOKEN_AND, TOKEN_CLASS, TOKEN_ELSE, TOKEN_FALSE,
    TOKEN_FOR, TOKEN_FUN, TOKEN_IF, TOKEN_NIL, TOKEN_OR, // 30
    TOKEN_PRINT, TOKEN_RETURN, TOKEN_SUPER, TOKEN_THIS,
    TOKEN_TRUE, TOKEN_VAR, TOKEN_WHILE, // 37

    // misc
    TOKEN_ERROR, TOKEN_EOF // 39
} TokenType;


typedef struct Token {
    TokenType type;
    const char *start;
    int length;
    int line;
} Token;

void initScanner(const char *source);

Token scanToken(void);

#endif // clox_scanner_h
