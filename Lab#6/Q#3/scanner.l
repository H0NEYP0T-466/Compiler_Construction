%{
#include "parser.tab.h"
%}
%%
"if"    return IF;
"else"  return ELSE;
"while" return WHILE;
[a-z]   { yylval.id = yytext[0]; return ID; }
[0-9]+  { yylval.num = atoi(yytext); return NUMBER; }
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
.       { printf("Invalid char\n"); }
%%
int yywrap() { return 1; }