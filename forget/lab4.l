%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int keyword_count = 0;
int identifier_count = 0;
int number_count = 0;
int string_count = 0;
int char_count = 0;
int operator_count = 0;
int invalid_count = 0;
%}

%option noyywrap
%option yylineno

%%

"int"|"float"|"if"|"else"|"while"|"return"|"for"|"do"|"switch" {
    printf("Keyword: %s (line %d)\n", yytext, yylineno);
    keyword_count++;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Identifier: %s (line %d)\n", yytext, yylineno);
    identifier_count++;
}

[0-9]+(\.[0-9]+)? {
    printf("Number: %s (line %d)\n", yytext, yylineno);
    number_count++;
}

\"([^\\\"]|\\.)*\" {
    printf("String Literal: %s (line %d)\n", yytext, yylineno);
    string_count++;
}

\'([^\\\']|\\.)\' {
    printf("Character Constant: %s (line %d)\n", yytext, yylineno);
    char_count++;
}

">="|"<="|"=="|"!=" {
    printf("Operator: %s (line %d)\n", yytext, yylineno);
    operator_count++;
}

"+"|"-"|"*"|"/"|"="|">"|"<" {
    printf("Operator: %s (line %d)\n", yytext, yylineno);
    operator_count++;
}

";"|"("|")"|"{"|"}" { }

"//".* { }

"/*"([^*]|\*+[^*/])*\*+"/" { }

[ \t\n]+ { }

. {
    printf("Invalid Token: %s (line %d)\n", yytext, yylineno);
    invalid_count++;
}

%%

int main() {
    yylex();
    printf("\n--- Token Summary ---\n");
    printf("Keywords: %d\n", keyword_count);
    printf("Identifiers: %d\n", identifier_count);
    printf("Numbers: %d\n", number_count);
    printf("String Literals: %d\n", string_count);
    printf("Character Constants: %d\n", char_count);
    printf("Operators: %d\n", operator_count);
    printf("Invalid Tokens: %d\n", invalid_count);
    return 0;
}