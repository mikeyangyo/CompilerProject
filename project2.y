%{
#define Trace(t)        printf(t)
%}

%union{
  float fval;
  int ival;
  char *sval;
}

%type <sval> ident
%type <ival> constant_i_expr
%type <fval> constant_f_expr
%type <sval> constant_s_expr
%type <sval> constant_b_expr
/* tokens */
%token SEMICOLON
%token <sval> IDENTIFIER
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
%token <sval> TRUE
%token <sval> FALSE
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
%token <ival> NUMBER
%token <fval> REALNUMBER
%token <sval> STRING

%start program
%left OR
%left AND
%left NOT
%left LESST LESSE EQUAL NEQUAL LARGERE LARGERT
%left PLUS MINUS
%left MULTIPLY DIVIDE
%left UMINUS
%%

program:        normal_declars func_declars
                {
                  Trace("Reducing to program\n");
                }
		|
		normal_declars
                {
                  Trace("Reducing to program\n");
                }
		|
		func_declars
                {
                  Trace("Reducing to program\n");
                }
		;
normal_declars:	normal_declars constant_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		|
		constant_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		|
		normal_declars variable_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		|
		variable_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		|
		normal_declars array_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		|
		array_declar SEMICOLON
                {
                  Trace("Reducing to normal declaration\n");
                }
		;

func_declars:	func_declars func_declar
                {
                  Trace("Reducing to function declaration\n");
                }
		|
		func_declar
                {
                  Trace("Reducing to function declaration\n");
                }
		;

constant_declar:LET ident COLON type ASSIGN constant_s_expr
		{
		  Trace("Reducing to constant declaration w/ type and initial value\n");
		}
		|
		LET ident ASSIGN constant_s_expr
		{
		  Trace("Reducing to constant declaration w/ initial value\n");
		  ID *nowID;
		  if((nowID = Search(Top(SymbolTables)->table, $2)) == NULL){
		    printf("Error: ID doesn't exist!\n");
		  }
		  else{
		    char *temp = strdup($4);
		    void *val = (void*)temp;
		    nowID->type = "nstr";
		    nowID->value = (char*)val;
		    printf("%s\n",(char*)nowID->value);
		    Dump(Top(SymbolTables)->table);
		  }
		}
		|
		LET ident COLON type ASSIGN constant_b_expr
		{
		  Trace("Reducing to constant declaration w/ type and initial value\n");
		}
		|
		LET ident ASSIGN constant_b_expr
		{
		  Trace("Reducing to constant declaration w/ initial value\n");
		  ID *nowID;
		  if((nowID = Search(Top(SymbolTables)->table, $2)) == NULL){
		    printf("Error: ID doesn't exist!\n");
		  }
		  else{
		    char *temp = strdup($4);
		    void *val = (void*)temp;
		    nowID->type = "nbool";
		    nowID->value = val;
		    printf("%s\n",(char*)nowID->value);
		    Dump(Top(SymbolTables)->table);
		  }
		}
		|
		LET ident COLON type ASSIGN constant_i_expr
		{
		  Trace("Reducing to constant declaration w/ type and initial value\n");
		}
		|
		LET ident ASSIGN constant_i_expr
		{
		  Trace("Reducing to constant declaration w/ initial value\n");
		  ID *nowID;
		  if((nowID = Search(Top(SymbolTables)->table, $2)) == NULL){
		    printf("Error: ID doesn't exist!\n");
		  }
		  else{
		    int *temp = (int*)malloc(sizeof(int));
		    *temp = $4;
		    void *val = (void*)temp;
		    nowID->type = "nint";
		    nowID->value = val;
		    Dump(Top(SymbolTables)->table);
		  }
		}
		|
		LET ident COLON type ASSIGN constant_f_expr
		{
		  Trace("Reducing to constant declaration w/ type and initial value\n");
		}
		|
		LET ident ASSIGN constant_f_expr
		{
		  Trace("Reducing to constant declaration w/ initial value\n");
		  ID *nowID;
		  if((nowID = Search(Top(SymbolTables)->table, $2)) == NULL){
		    printf("Error: ID doesn't exist!\n");
		  }
		  else{
		    float *temp = (float*)malloc(sizeof(float));
		    *temp = $4;
		    void *val = (void*)temp;
		    nowID->type = "nfloat";
		    nowID->value = val;
		    Dump(Top(SymbolTables)->table);
		  }
		}
		;

variable_declar:LET MUT ident COLON type ASSIGN constant_expr
		{
		  Trace("Reducing to variable declaration w/ type and initial value\n");
		}
		|
		LET MUT ident COLON type
		{
		  Trace("Reducing to variable declaration w/ type\n");
		}
		|
		LET MUT ident ASSIGN constant_expr
		{
		  Trace("Reducing to variable declaration w/ initial value\n");
		}
		|
		LET MUT ident
		{
		  Trace("Reducing to variable declaration w/ no type and initial value\n");
		}
		;

array_declar:	LET MUT ident SBRACKETSL type COMMA constant_expr SBRACKETSR
		{
		  Trace("Reducing to array declaration w/ type and # of elements\n");
		}
		;

func_declar:	FN ident PARENTHESESL func_argument PARENTHESESR MINUS LARGERT type block
		{
		  Trace("Reducing to function declaration w/ arguments and return type\n");
		}
		|
		FN ident PARENTHESESL PARENTHESESR MINUS LARGERT type block
		{
		  Trace("Reducing to function declaration w/ return type\n");
		}
		|
		FN ident PARENTHESESL PARENTHESESR block
		{
		  Trace("Reducing to function declaration w/ no arguments and no return type\n");
		}
		|
		FN ident PARENTHESESL func_argument PARENTHESESR block
		{
		  Trace("Reducing to function declaration w/ arguments\n");
		}
		;

func_argument:	func_argument COMMA ident COLON type
		|
		ident COLON type
		;

stmts:		stmts simple_stmt SEMICOLON
		{
		  Trace("Reducing to statements\n");
		}
		|
		simple_stmt SEMICOLON
		{
		  Trace("Reducing to statements\n");
		}
		|
		stmts block
		{
		  Trace("Reducing to statements\n");
		}
		|
		block
		{
		  Trace("Reducing to statements\n");
		}
		|
		stmts conditional
		{
		  Trace("Reducing to statements\n");
		}
		|
		conditional
		{
		  Trace("Reducing to statements\n");
		}
		|
		stmts loop
		{
		  Trace("Reducing to statements\n");
		}
		|
		loop
		{
		  Trace("Reducing to statements\n");
		}
		|
		stmts func_invoke
		{
		  Trace("Reducing to statements\n");
		}
		|
		func_invoke
		{
		  Trace("Reducing to statements\n");
		}
		;

block:		CBRACKETSL normal_declars stmts CBRACKETSR
		{
		  Trace("Reducing to block w/ normal declaration and statements\n");
		}
		|
		CBRACKETSL stmts CBRACKETSR
		{
		  Trace("Reducing to block w/ statements\n");
		}
		;

simple_stmt:	ident ASSIGN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		ident SBRACKETSL SBRACKETSR ASSIGN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		PRINT expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		PRINTLN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		READ ident
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		RETURN
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		RETURN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		;

expr:		integer_expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		boolean_expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		MINUS expr %prec UMINUS
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr LESST expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr LESSE expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr LARGERT expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr LARGERE expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr EQUAL expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		expr NEQUAL expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		constant_expr
		{
		  Trace("Reducing to expression\n");
		}
		|
		ident
		{
		  Trace("Reducing to expression\n");
		}
		|
		func_invoke
		{
		  Trace("Reducing to expression\n");
		}
		|
		array_ref
		{
		  Trace("Reducing to expression\n");
		}
		;

integer_expr:	integer_expr PLUS integer_expr
		|
		integer_expr MINUS integer_expr
		|
		integer_expr MULTIPLY integer_expr
		|
		integer_expr DIVIDE integer_expr
		|
		NUMBER
		|
		ident
		;

boolean_expr:	boolean_expr AND boolean_expr
		|
		boolean_expr OR boolean_expr
		|
		NOT boolean_expr
		|
		TRUE
		|
		FALSE
		;

constant_s_expr:STRING
		{
		  $$ = yytext;
		}
		;
constant_b_expr:TRUE
		{
		  $$ = "true";
		}
		|
		FALSE
		{
		  $$ = "false";
		}
		;

constant_i_expr:NUMBER
		{
		  $$ = atoi(yytext);
		}
		;

constant_f_expr:REALNUMBER
		{
		  $$ = atof(yytext);
		}
		;

array_ref:	ident SBRACKETSL integer_expr SBRACKETSR
		;

func_invoke:	ident PARENTHESESL func_invoke_arg PARENTHESESR
		{
		  Trace("Reducing to function invocation\n");
		}
		;

func_invoke_arg:func_invoke_arg COMMA expr
		|
		expr
		;

conditional:	IF PARENTHESESL boolean_expr PARENTHESESR block ELSE block
		{
		  Trace("Reducing to conditional statement w/ else\n");
		}
		|
		IF PARENTHESESL boolean_expr PARENTHESESR block
		{
		  Trace("Reducing to conditional statement w/ no else\n");
		}
		;

loop:		WHILE PARENTHESESL boolean_expr PARENTHESESR block
		{
		  Trace("Reducing to loop\n");
		}
		;

type:		INT|STR|BOOL|FLOAT
		;

ident:		IDENTIFIER
		{
		  if(Search(Top(SymbolTables)->table, $1) == NULL){
		    ID *newID = CreateID($1);
		    Insert(Top(SymbolTables)->table, CreateID($1));
		  }
		  $$ = $1;
		}
		;
%%
#include "lex.yy.c"

IDstk *SymbolTables = NULL;

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

    /* create the stack of tables */
    SymbolTables = stkCreate();

    /* perform parsing */
    if (yyparse() == 1)                 /* parsing */
        yyerror("Parsing error !");     /* syntax error */
}

