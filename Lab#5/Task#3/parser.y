%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int yylex();
void yyerror(const char *s);
%}

%union { double num; }
%token <num> NUMBER
%token <num> EQ NE LE GE
%type  <num> expr

%nonassoc EQ NE LE GE
%left  '<' '>'
%left  '+' '-'
%left  '*' '/' '%'
%right UMINUS
%right '^'

%%

program:
    program expr '\n'  { printf("Result = %.6g\n\n", $2); }
  | program '\n'       { }
  | /* empty */
  ;

expr:
    expr '+' expr           { $$ = $1 + $3; }
  | expr '-' expr           { $$ = $1 - $3; }
  | expr '*' expr           { $$ = $1 * $3; }
  | expr '/' expr           { if($3==0){yyerror("divide by zero");$$=0;}
                              else $$ = $1/$3; }
  | expr '%' expr           { $$ = fmod($1,$3); }
  | expr '^' expr           { $$ = pow($1,$3); }
  | '-' expr %prec UMINUS   { $$ = -$2; }
  | '(' expr ')'            { $$ = $2; }
  | expr '<' expr           { $$ = ($1 <  $3) ? 1 : 0; }
  | expr '>' expr           { $$ = ($1 >  $3) ? 1 : 0; }
  | expr LE  expr           { $$ = ($1 <= $3) ? 1 : 0; }
  | expr GE  expr           { $$ = ($1 >= $3) ? 1 : 0; }
  | expr EQ  expr           { $$ = ($1 == $3) ? 1 : 0; }
  | expr NE  expr           { $$ = ($1 != $3) ? 1 : 0; }
  | NUMBER                  { $$ = $1; }
  ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Expression Evaluator (with comparisons)\n");
    printf("Type Ctrl+D to quit.\n\n");
    yyparse();
    return 0;
}