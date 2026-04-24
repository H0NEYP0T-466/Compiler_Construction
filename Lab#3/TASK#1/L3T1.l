%option noyywrap
%{
#include <stdio.h>
%}

%%

"int"     { printf("KEYWORD: %s\n", yytext); }
"float"   { printf("KEYWORD: %s\n", yytext); }
"char"    { printf("KEYWORD: %s\n", yytext); }
"if"      { printf("KEYWORD: %s\n", yytext); }
"else"    { printf("KEYWORD: %s\n", yytext); }
"while"   { printf("KEYWORD: %s\n", yytext); }
"return"  { printf("KEYWORD: %s\n", yytext); }
"for"     { printf("KEYWORD: %s\n", yytext); }
"do"      { printf("KEYWORD: %s\n", yytext); }
"switch"  { printf("KEYWORD: %s\n", yytext); }

[a-zA-Z][a-zA-Z0-9_]*  { printf("IDENTIFIER: %s\n", yytext); }
[0-9]+                  { printf("NUMBER: %s\n", yytext); }
[ \t\n]               ;
.                       ;

%%

int main() {
    yylex();
    return 0;
}
