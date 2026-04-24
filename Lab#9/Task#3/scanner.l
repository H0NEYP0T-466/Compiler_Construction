%{
#include "parser.tab.h"
%}

%%

"if"      return IF;
"else"    return ELSE;
"while"   return WHILE;

[a-z]     { yylval.id = yytext[0]; return ID; }
[0-9]+    { yylval.num = atoi(yytext); return NUMBER; }

[ \t\n]   ;
.         return yytext[0];

%%

int yywrap() { return 1; }