%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    char        *value;
    struct node *left;
    struct node *right;
    int          result;   /* NEW: stores evaluated result */
} node;

node* createNode(char* val, node* left, node* right, int result);
void  printTree(node* root, int space);
int   yylex();
void  yyerror(const char *s);

node* root;
%}

%union {
    int   num;
    node* ptr;
}

%token <num> NUMBER
%type  <ptr> expr

%left '+' '-'
%left '*' '/'

%%

input:
    expr '\n' {
        root = $1;
        printf("\nParse Tree:\n");
        printTree(root, 0);
        printf("Result = %d\n", root->result);   /* NEW */
    }
    ;

expr:
    expr '+' expr {
        int r = $1->result + $3->result;
        $$ = createNode("+", $1, $3, r);
    }
    | expr '-' expr {
        int r = $1->result - $3->result;
        $$ = createNode("-", $1, $3, r);
    }
    | expr '*' expr {
        int r = $1->result * $3->result;
        $$ = createNode("*", $1, $3, r);
    }
    | expr '/' expr {
        int r = $1->result / $3->result;
        $$ = createNode("/", $1, $3, r);
    }
    | '(' expr ')' { $$ = $2; }
    | NUMBER {
        char buffer[20];
        sprintf(buffer, "%d", $1);
        $$ = createNode(buffer, NULL, NULL, $1);   /* leaf: result = number itself */
    }
    ;

%%

node* createNode(char* val, node* left, node* right, int result) {
    node* newNode       = (node*)malloc(sizeof(node));
    newNode->value      = strdup(val);
    newNode->left       = left;
    newNode->right      = right;
    newNode->result     = result;   /* store it */
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