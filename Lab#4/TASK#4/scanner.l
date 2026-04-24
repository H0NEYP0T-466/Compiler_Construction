%{
typedef struct node {
    char        *value;
    struct node *left;
    struct node *right;
    double       result;
} node;

#include "parser.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+(\.[0-9]+)?   { yylval.num = atof(yytext); return NUMBER; }   /* NEW: accepts 3.14 */
[ \t]               ;
\n                  return '\n';
.                   return yytext[0];
%%

int yywrap() { return 1; }