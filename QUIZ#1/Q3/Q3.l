%option noyywrap
%{
#include <stdio.h>
int lineNum = 1;
%}

KEYWORD    int|float|if|else
IDENT      [a-zA-Z_][a-zA-Z0-9_]*
INT        [0-9]+
INV_IDENT  [0-9]+[a-zA-Z_][a-zA-Z0-9_]*
WS         [ \t]+

%%

{KEYWORD}   { printf("KEYWORD     : %s\n", yytext); }
{IDENT}     { printf("IDENTIFIER  : %s\n", yytext); }
{INT}       { printf("INTEGER     : %s\n", yytext); }
{INV_IDENT} { printf("Error at line %d: Invalid Identifier %s\n", lineNum, yytext); }
\n          { lineNum++; }
{WS}        { /* skip */ }
.           { printf("Error at line %d: Invalid Token %s\n", lineNum, yytext); }

%%

int main() {
    yylex();
    return 0;
}
