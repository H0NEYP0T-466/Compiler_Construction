%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
%}

NUM    [0-9]+
WS     [ \t\n]+

%%

{NUM} {
    int n = atoi(yytext);
    if (n % 2 == 0)
        printf("%d is Even\n", n);
    else
        printf("%d is Odd\n", n);
}
{WS}  { /* ignore whitespace */ }
.     { printf("Invalid Input: %s\n", yytext); }

%%

int main() {
    printf("Enter a number: ");
    yylex();
    return 0;
}
