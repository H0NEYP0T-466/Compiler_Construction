%{
#include "parser.tab.h"
#include <stdlib.h>
%}
%%
[0-9]+(\.[0-9]+)?   { yylval.num = atof(yytext); return NUMBER; }
"<="                { return LE; }
">="                { return GE; }
"=="                { return EQ; }
"!="                { return NE; }
"pi"  { yylval.num = 3.14159265358979; return NUMBER; }
"e"   { yylval.num = 2.71828182845905; return NUMBER; }

[ \t]               ;
\n                  return '\n';
.                   return yytext[0];
%%
int yywrap() { return 1; }