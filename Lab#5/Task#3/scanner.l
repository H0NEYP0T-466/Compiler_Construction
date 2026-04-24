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
[ \t]               ;
\n                  return '\n';
.                   return yytext[0];
%%
int yywrap() { return 1; }