%option noyywrap
%{
#include <stdio.h>
%}

KEYWORD   int|float|char|if|else|return
IDENT     [a-zA-Z_][a-zA-Z0-9_]*
INT       [0-9]+
FLOAT     [0-9]+\.[0-9]+
STRING    \"[^\"\n]*\"
CHAR_LIT  \'[^'\n]\'
OP        [+\-*\/=]|==|!=|>=|<=
SPECIAL   [;,(){}]
WS        [ \t\n]+

%%

{KEYWORD}   { printf("KEYWORD     : %s\n", yytext); }
{FLOAT}     { printf("FLOAT CONST : %s\n", yytext); }
{INT}       { printf("INT CONST   : %s\n", yytext); }
{STRING}    { printf("STRING LIT  : %s\n", yytext); }
{CHAR_LIT}  { printf("CHAR LIT    : %s\n", yytext); }
{IDENT}     { printf("IDENTIFIER  : %s\n", yytext); }
{OP}        { printf("OPERATOR    : %s\n", yytext); }
{SPECIAL}   { printf("SPECIAL SYM : %s\n", yytext); }
{WS}        { /* ignore whitespace */ }
.           { printf("Invalid Token: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
