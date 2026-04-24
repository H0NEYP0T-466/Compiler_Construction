%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
void yyerror(const char *s);
int variables[26];
%}

%union { int num; char id; }
%token <num> NUMBER
%token <id>  ID
%token IF ELSE WHILE DO
%token LE GE EQ NE

%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/'
%type <num> expr

%%

program
  : program stmt
  |
  ;

stmt
  : assignment
  | if_stmt
  | while_stmt
  | do_while_stmt
  | block
  ;

block
  : '{' stmt_list '}'  { printf("Block executed\n"); }
  ;

stmt_list
  : stmt_list stmt
  |
  ;

assignment
  : ID '=' expr ';'
    { variables[$1-'a'] = $3; printf("Assigned %c = %d\n", $1, $3); }
  ;

if_stmt
  : IF '(' expr ')' stmt ELSE stmt
    { if($3) printf("IF true\n"); else printf("ELSE executed\n"); }
  | IF '(' expr ')' stmt
    { if($3) printf("IF true\n"); }
  ;

while_stmt
  : WHILE '(' expr ')' stmt
    { if($3) printf("Loop executing...\n"); }
  ;

do_while_stmt
  : DO stmt WHILE '(' expr ')' ';'
    {
        printf("do-while: body ran at least once\n");
        if($5) printf("do-while: condition TRUE\n");
        else   printf("do-while: condition FALSE, loop ends\n");
    }
  ;

expr
  : expr '+' expr  { $$ = $1 + $3; }
  | expr '-' expr  { $$ = $1 - $3; }
  | expr '*' expr  { $$ = $1 * $3; }
  | expr '/' expr  { $$ = $1 / $3; }
  | expr '<' expr  { $$ = $1 <  $3; }
  | expr '>' expr  { $$ = $1 >  $3; }
  | expr LE  expr  { $$ = $1 <= $3; }
  | expr GE  expr  { $$ = $1 >= $3; }
  | expr EQ  expr  { $$ = $1 == $3; }
  | expr NE  expr  { $$ = $1 != $3; }
  | NUMBER         { $$ = $1; }
  | ID             { $$ = variables[$1-'a']; }
  ;

%%

void yyerror(const char *s) { printf("Syntax Error: %s\n", s); }
int main() { printf("Enter program:\n"); yyparse(); return 0; }