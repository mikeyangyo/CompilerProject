%{
#define Trace(t)        printf(t)
%}

/* tokens */
%token SEMICOLON
%token IDENTIFIER
%token FN
%token PRINTLN
%token BOOL
%token BREAK
%token CHAR
%token CONTINUE
%token DO
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token IF
%token IN
%token INT
%token LET
%token LOOP
%token MATCH
%token MUT
%token PRINT
%token PUB
%token RETURN
%token SELF
%token STATIC
%token STR
%token STRUCT
%token USE
%token WHERE
%token WHILE
%token TRUE
%token FALSE
%token COMMA
%token COLON
%token PARENTHESESL
%token PARENTHESESR
%token SBRACKETSL
%token SBRACKETSR
%token CBRACKETSL
%token CBRACKETSR
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token DPLUS
%token DMINUS
%token MOD
%token LESST
%token LESSE
%token LARGERT
%token LARGERE
%token EQUAL
%token NEQUAL
%token AND
%token OR
%token NOT
%token ASSIGN
%token PLUSE
%token MINUSE
%token MULTIPLYE
%token DIVIDEE
%token NUMBER
%token REALNUMBER
%token STRING
%token COMMENT
%token COMMENTB
%token NEWLINE

%start program
%%

program:        constant_declar COLON
                {
                  Trace("Reducing to program\n");
                }
		|
		program NEWLINE
		{
		  Trace("Reducing to program\n");
		}
		;

constant_declar: LET IDENTIFIER
		|
		constant_declar COLON type
		|
		constant_declar ASSIGN constant_expr
		{
		  Trace("Reducing to constant declarations\n");
		}
		;

type:		INT|STR|BOOL|FLOAT;

constant_expr:   STRING|NUMBER|TRUE|FALSE|REALNUMBER;

%%
#include "lex.yy.c"

yyerror(msg)
char *msg;
{
    fprintf(stderr, "%s\n", msg);
}

main(int argc, char **argv)
{
    /* open the source program file */
    if (argc != 2) {
        printf ("Usage: sc filename\n");
        exit(1);
    }
    yyin = fopen(argv[1], "r");         /* open input file */
    /* perform parsing */
    if (yyparse() == 1)                 /* parsing */
        yyerror("Parsing error !");     /* syntax error */
}

