%{
#define Trace(t)        printf(t)
%}

/* tokens */
%token SEMICOLON
%token idenifier
%%
/*program:        identifier semi
                {
                Trace("Reducing to program\n");
                }
                ;
*/
semi:           SEMICOLON
                {
                Trace("Reducing to semi\n");
                }
                ;
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
    printf("filename = %s\n", argv[1]);
    /* perform parsing */
    if (yyparse() == 1)                 /* parsing */
        yyerror("Parsing error !");     /* syntax error */
}

