%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>     /* for pow() */

typedef struct node {
    char        *value;
    struct node *left;
    struct node *right;
    double       result;
} node;

node* createNode(char* val, node* left, node* right, double result);
void  printTree(node* root, int space);
int   yylex();
void  yyerror(const char *s);

node* root;
%}

%union {
    double num;
    node*  ptr;
}

%token <num> NUMBER
%type  <ptr> expr

%left  '+' '-'
%left  '*' '/' '%'
%right '^'          /* ^ is right-associative and highest precedence */

%%

input:
    expr '\n' {
        root = $1;
        printf("\nParse Tree:\n");
        printTree(root, 0);
        printf("Result = %.6g\n", root->result);
    }
    ;

expr:
    expr '+' expr {
        double r = $1->result + $3->result;
        $$ = createNode("+", $1, $3, r);
    }
    | expr '-' expr {
        double r = $1->result - $3->result;
        $$ = createNode("-", $1, $3, r);
    }
    | expr '*' expr {
        double r = $1->result * $3->result;
        $$ = createNode("*", $1, $3, r);
    }
    | expr '/' expr {
        double r = $1->result / $3->result;
        $$ = createNode("/", $1, $3, r);
    }
    | expr '%' expr {
        double r = (double)((int)$1->result % (int)$3->result);
        $$ = createNode("%", $1, $3, r);
    }
    | expr '^' expr {                              /* NEW */
        double r = pow($1->result, $3->result);
        $$ = createNode("^", $1, $3, r);
    }
    | '(' expr ')' { $$ = $2; }
    | NUMBER {
        char buffer[32];
        sprintf(buffer, "%.6g", $1);
        $$ = createNode(buffer, NULL, NULL, $1);
    }
    ;

%%

node* createNode(char* val, node* left, node* right, double result) {
    node* newNode   = (node*)malloc(sizeof(node));
    newNode->value  = strdup(val);
    newNode->left   = left;
    newNode->right  = right;
    newNode->result = result;
    return newNode;
}

void printTree(node* root, int space) {
    int i;
    if (root == NULL) return;
    for (i = 0; i < space; i++) printf(" ");
    printf("%s\n", root->value);
    printTree(root->left,  space + 1);
    printTree(root->right, space + 1);
}

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}