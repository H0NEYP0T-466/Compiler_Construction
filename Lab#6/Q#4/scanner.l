%{
#include "parser.tab.h"
%}
%%
"if"    return IF;
"else"  return ELSE;
"while" return WHILE;
"do"    return DO;
[a-z]   { yylval.id = yytext[0]; return ID; }
[0-9]+  { yylval.num = atoi(yytext); return NUMBER; }
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
"<"     return '<';
">"     return '>';
"="     return '=';
";"     return ';';
"("     return '(';
")"     return ')';
"{"     return '{';
"}"     return '}';
"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
[ \t\n] ;
.       { printf("Invalid char: %s\n", yytext); }
%%
int yywrap() { return 1; }