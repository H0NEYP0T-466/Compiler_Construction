%option noyywrap
%{
#include <stdio.h>
#include <string.h>

#define MAX 100
char symbolTable[MAX][64];
int count = 0;

int lookup(char *name) {
    for (int i = 0; i < count; i++)
        if (strcmp(symbolTable[i], name) == 0) return 1;
    return 0;
}

void insert(char *name) {
    strcpy(symbolTable[count++], name);
}
%}

IDENT  [a-zA-Z_][a-zA-Z0-9_]*
WS     [ \t\n]+

%%

{IDENT} {
    if (lookup(yytext)) {
        printf("Duplicate Identifier: %s\n", yytext);
    } else {
        insert(yytext);
        printf("Identifier Added: %s\n", yytext);
    }
}
{WS}  { /* ignore */ }
.     { printf("Invalid Token: %s\n", yytext); }

%%

int main() {
    yylex();
    printf("\n--- Symbol Table ---\n");
    for (int i = 0; i < count; i++)
        printf("%d: %s\n", i+1, symbolTable[i]);
    return 0;
}
