%{
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int type;
    int value;
    char id;
    struct Node *left, *right, *extra;
} Node;

#define NODE_NUM    1
#define NODE_VAR    2
#define NODE_GT     8
#define NODE_ASSIGN 13
#define NODE_IF     15
#define NODE_IFELSE 16

Node* makeNode(int type, Node* left, Node* extra, Node* right) {
    Node* n = (Node*)malloc(sizeof(Node));
    n->type  = type;
    n->value = 0;
    n->id    = 0;
    n->left  = left;
    n->extra = extra;
    n->right = right;
    return n;
}

void indent(int depth) {
    int i;
    for(i = 0; i < depth; i++) printf("  ");
}

void printAST(Node* n, int depth) {
    if (!n) return;
    indent(depth);
    switch (n->type) {
        case NODE_NUM:
            printf("NUM(%d)\n", n->value);
            break;
        case NODE_VAR:
            printf("VAR(%c)\n", n->id);
            break;
        case NODE_GT:
            printf("GT\n");
            printAST(n->left,  depth+1);
            printAST(n->right, depth+1);
            break;
        case NODE_ASSIGN:
            printf("ASSIGN(%c)\n", n->left->id);
            printAST(n->right, depth+1);
            break;
        case NODE_IF:
            printf("IF\n");
            indent(depth+1); printf("[condition]\n");
            printAST(n->left,  depth+2);
            indent(depth+1); printf("[then-body]\n");
            printAST(n->extra, depth+2);
            break;
        case NODE_IFELSE:
            printf("IFELSE\n");
            indent(depth+1); printf("[condition]\n");
            printAST(n->left,  depth+2);
            indent(depth+1); printf("[then-body]\n");
            printAST(n->extra, depth+2);
            indent(depth+1); printf("[else-body]\n");
            printAST(n->right, depth+2);
            break;
    }
}

int yylex();
void yyerror(const char *s);
%}

%union { int num; char id; void* node; }
%token <num> NUMBER
%token <id>  ID
%token IF ELSE
%token LE GE EQ NE

%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/'
%type <node> expr stmt if_stmt assignment

%%

program
  : program stmt
    {
        printf("\n--- AST ---\n");
        printAST((Node*)$2, 0);
    }
  |
  ;

stmt
  : assignment  { $$ = $1; }
  | if_stmt     { $$ = $1; }
  ;

assignment
  : ID '=' expr ';'
    {
        Node* var = makeNode(NODE_VAR, NULL, NULL, NULL);
        var->id = $1;
        $$ = makeNode(NODE_ASSIGN, var, NULL, (Node*)$3);
    }
  ;

if_stmt
  : IF '(' expr ')' stmt ELSE stmt
    { $$ = makeNode(NODE_IFELSE, (Node*)$3, (Node*)$5, (Node*)$7); }
  | IF '(' expr ')' stmt
    { $$ = makeNode(NODE_IF, (Node*)$3, (Node*)$5, NULL); }
  ;

expr
  : expr '>' expr
    { $$ = makeNode(NODE_GT, (Node*)$1, NULL, (Node*)$3); }
  | NUMBER
    {
        Node* n = makeNode(NODE_NUM, NULL, NULL, NULL);
        n->value = $1;
        $$ = n;
    }
  | ID
    {
        Node* n = makeNode(NODE_VAR, NULL, NULL, NULL);
        n->id = $1;
        $$ = n;
    }
  ;

%%

void yyerror(const char *s) { printf("Syntax Error: %s\n", s); }
int main() { printf("Enter program:\n"); yyparse(); return 0; }