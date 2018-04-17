%{
#define Trace(t) if(Opt_P) printf(t)
int Opt_P = 1;
%}

/*tokens*/
%token SEMICOLON
%%
program: identifier semi
	 {
	   Trace("Reducing to program.\n");
	 }
	 ;
semi:	 SEMICOLON
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

main(){
  yyparse();
}
