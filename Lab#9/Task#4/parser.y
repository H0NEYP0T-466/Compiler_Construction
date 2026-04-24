%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

int temp_count = 0;
int label_count = 0;

char* newTemp() {
    char *buf = malloc(10);
    sprintf(buf, "t%d", ++temp_count);
    return buf;
}

char* newLabel() {
    char *buf = malloc(10);
    sprintf(buf, "L%d", ++label_count);
    return buf;
}
%}

%union {
    int   num;
    char  id;
    char *tmp;
}

%token <num> NUMBER
%token <id>  ID
%token IF ELSE WHILE PRINT

%left '+' '-'
%left '*' '/'

%type <tmp> expr

%%

program:
      program stmt
    | /* empty */
    ;

stmt:
      assign_stmt
    | print_stmt
    ;

assign_stmt:
    ID '=' expr ';'
    {
        printf("%c = %s\n", $1, $3);
        free($3);
    }
    ;

print_stmt:
    PRINT ID ';'
    {
        printf("print %c\n", $2);
    }
    ;

expr:
      expr '+' expr
    {
        char *t = newTemp();
        printf("%s = %s + %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | expr '-' expr
    {
        char *t = newTemp();
        printf("%s = %s - %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | expr '*' expr
    {
        char *t = newTemp();
        printf("%s = %s * %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | expr '/' expr
    {
        char *t = newTemp();
        printf("%s = %s / %s\n", t, $1, $3);
        free($1); free($3);
        $$ = t;
    }
    | '(' expr ')'   { $$ = $2; }
    | NUMBER
    {
        char *t = newTemp();
        printf("%s = %d\n", t, $1);
        $$ = t;
    }
    | ID
    {
        char *t = malloc(4);
        t[0] = $1; t[1] = '\0';
        $$ = t;
    }
    ;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("=== TAC Generator ===\n");
    yyparse();
    return 0;
}