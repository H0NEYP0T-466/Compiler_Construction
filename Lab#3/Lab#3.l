%option noyywrap

%{
#include<stdio.h>
%}

%%

"int"      { printf("Keyword: %s\n", yytext); }
"float"    { printf("Keyword: %s\n", yytext); }
"if"       { printf("Keyword: %s\n", yytext); }
"else"     { printf("Keyword: %s\n", yytext); }
"while"    { printf("Keyword: %s\n", yytext); }
"return"   { printf("Keyword: %s\n", yytext); }

[a-zA-Z][a-zA-Z0-9]*   { printf("Identifier: %s\n", yytext); }

[0-9]+     { printf("Number: %s\n", yytext); }

"+"|"-"|"*"|"/"|"="   { printf("Operator: %s\n", yytext); }

";"|"("|")"|"{"|"}"   { printf("Symbol: %s\n", yytext); }

[ \t\n]+   ;  

.          { printf("Invalid Token: %s\n", yytext); }

%%

int main()
{
    yylex();
    return 0;
}