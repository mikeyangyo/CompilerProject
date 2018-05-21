%{
#define Trace(t)        printf(t)
%}

%union{
  float fval;
  int ival;
  char *sval;
}

%type <sval> constant_expr
%type <sval> type
%type <sval> expr
%type <sval> integer_expr
%type <sval> integer_expr_arg
%type <sval> boolean_expr
%type <sval> boolean_expr_arg
%type <sval> func_invoke
/* tokens */
%token SEMICOLON
%token <sval> IDENTIFIER
%token FN
%token PRINTLN
%token <sval> BOOL
%token BREAK
%token CHAR
%token CONTINUE
%token DO
%token ELSE
%token ENUM
%token EXTERN
%token <sval> FLOAT
%token FOR
%token IF
%token IN
%token <sval> INT
%token LET
%token LOOP
%token MATCH
%token MUT
%token PRINT
%token PUB
%token RETURN
%token SELF
%token STATIC
%token <sval> STR
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
%token <sval> NUMBER
%token <sval> REALNUMBER
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

constant_declar:LET IDENTIFIER COLON type ASSIGN constant_expr
		{
		  Trace("Reducing to constant declaration w/ type and initial value\n");
		  if(Search(Top(SymbolTables)->table, $2) == NULL){
		    ID *newID = CreateID($2);

		    if(nowType == 0){
		      if(strcmp("int", $4) != 0){
		        printf("Error: %d is not %s type\n", atoi($6), $4);
		      }
		      else{
		        int *temp = (int*)malloc(sizeof(int));
		        *temp = atoi($6);
		        void *val = (void*)temp;
		        newID->type = "int";
		        newID->value = val;
		        nowType = -1;
		        Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		    else if(nowType == 1){
		      if(strcmp("float", $4) != 0){
		        printf("Error: %f is not %s type\n", atof($6), $4);
		      }
		      else{
		        float *temp = (float*)malloc(sizeof(float));
		        *temp = atof($6);
		        void *val = (void*)temp;
		        newID->type = "float";
		        newID->value = val;
		        nowType = -1;
		        Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		    else if(nowType == 2){
		      if(strcmp("str", $4) != 0){
		        printf("Error: %s is not %s type\n", $6, $4);
		      }
		      else{
		        char *temp = strdup($6);
		        void *val = (void*)temp;
		        newID->type = "str";
		        newID->value = val;
		        nowType = -1;
		        Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		    else if(nowType == 3){
		      if(strcmp("bool", $4) != 0){
		        printf("Error: %s is not %s type\n", $6, $4);
		      }
		      else{
		        char *temp = strdup($6);
		        void *val = (void*)temp;
		        newID->type = "bool";
		        newID->value = val;
		        nowType = -1;
		        Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		    else{
		      printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		      nowType = -1;
		    }		  
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("Error: %s already exists!", $2);
		  }
		}
		|
		LET IDENTIFIER ASSIGN constant_expr
		{
		  Trace("Reducing to constant declaration w/ initial value\n");
		  if(Search(Top(SymbolTables)->table, $2) == NULL){
		    ID *newID = CreateID($2);

		    if(nowType == 0){
		      int *temp = (int*)malloc(sizeof(int));
		      *temp = atoi($4);
		      void *val = (void*)temp;
		      newID->type = "nint";
		      newID->value = val;
		      nowType = -1;
		      Insert(Top(SymbolTables)->table, newID);
		    }
		    else if(nowType == 1){
		      float *temp = (float*)malloc(sizeof(float));
		      *temp = atof($4);
		      void *val = (void*)temp;
		      newID->type = "nfloat";
		      newID->value = val;
		      nowType = -1;
		      Insert(Top(SymbolTables)->table, newID);
		    }
		    else if(nowType == 2){
		      char *temp = strdup($4);
		      void *val = (void*)temp;
		      newID->type = "nstr";
		      newID->value = val;
		      nowType = -1;
		      Insert(Top(SymbolTables)->table, newID);
		    }
		    else if(nowType == 3){
		      char *temp = strdup($4);
		      void *val = (void*)temp;
		      newID->type = "nbool";
		      newID->value = val;
		      nowType = -1;
		      Insert(Top(SymbolTables)->table, newID);
		    }
		    else{
		      printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		      nowType = -1;
		    }
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("Error: %s already exists!", $2);
		  }
		}
		;

variable_declar:LET MUT IDENTIFIER COLON type ASSIGN constant_expr
		{
		  Trace("Reducing to variable declaration w/ type and initial value\n");
		  int existed = 1;
		  ID *newID = Search(Top(SymbolTables)->table, $3);

		  if(newID == NULL){
		    newID = CreateID($3);
		    existed = 0;
		  }

		  if(nowType == 0){
		    if(strcmp("int", $5) != 0){
		      printf("Error: %d is not %s type\n", atoi($7), $5);
		    }
		    else{
		      int *temp = (int*)malloc(sizeof(int));
		      *temp = atoi($7);
		      void *val = (void*)temp;
		      newID->type = "int";
		      newID->value = val;
		      nowType = -1;
		      if(existed == 0){
			Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		  }
		  else if(nowType == 1){
		    if(strcmp("float", $5) != 0){
		      printf("Error: %f is not %s type\n", atof($7), $5);
		    }
		    else{
		      float *temp = (float*)malloc(sizeof(float));
		      *temp = atof($7);
		      void *val = (void*)temp;
		      newID->type = "float";
		      newID->value = val;
		      nowType = -1;
		      if(existed == 0){
			Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		  } 
		  else if(nowType == 2){
		    if(strcmp("str", $5) != 0){
		      printf("Error: %s is not %s type\n", $7, $5);
		    }
		    else{
		      char *temp = strdup($7);
		      void *val = (void*)temp;
		      newID->type = "str";
		      newID->value = val;
		      nowType = -1;
		      if(existed == 0){
			Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		  }
		  else if(nowType == 3){
		    if(strcmp("bool", $5) != 0){
		      printf("Error: %s is not %s type\n", $7, $5);
		    }
		    else{
		      char *temp = strdup($7);
		      void *val = (void*)temp;
		      newID->type = "bool";
		      newID->value = val;
		      nowType = -1;
		      if(existed == 0){
			Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		  }
		  else{
		    printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		    nowType = -1;
		  }		  
		  Dump(Top(SymbolTables)->table);
		}
		|
		LET MUT IDENTIFIER COLON type
		{
		  Trace("Reducing to variable declaration w/ type\n");
		  int existed = 1;
		  ID *newID = Search(Top(SymbolTables)->table, $3);

		  if(newID == NULL){
		    newID = CreateID($3);
		    existed = 0;
		  }

		  if(newID->value == NULL){
		    newID->type = $5;
		  }
		  else{
		    char *temp = strdup("n");
		    strcat(temp, $5);

		    if(strcmp(temp, newID->type) == 0){
		      newID->type = $5;
		    }
		    else{
		      printf("Error: Unsuitable type!\n");
		    }
		  }

		  if(existed == 0){
		    Insert(Top(SymbolTables)->table, newID);
		  }
		  Dump(Top(SymbolTables)->table);
		}
		|
		LET MUT IDENTIFIER ASSIGN constant_expr
		{
		  Trace("Reducing to variable declaration w/ initial value\n");
		  int existed = 1;
		  ID *newID = Search(Top(SymbolTables)->table, $3);

		  if(newID == NULL){
		    newID = CreateID($3);
		    existed = 0;
		  }
                  if(nowType == 0){
		    int *temp = (int*)malloc(sizeof(int));
		    *temp = atoi($5);
		    void *val = (void*)temp;
		    newID->type = "nint";
		    newID->value = val;
		    nowType = -1;
		    if(existed == 0){
		      Insert(Top(SymbolTables)->table, newID);
		    }
		  }
		  else if(nowType == 1){
		    float *temp = (float*)malloc(sizeof(float));
		    *temp = atof($5);
		    void *val = (void*)temp;
		    newID->type = "nfloat";
		    newID->value = val;
		    nowType = -1;
		    if(existed == 0){
		      Insert(Top(SymbolTables)->table, newID);
		    }
		  }
		  else if(nowType == 2){
		    char *temp = strdup($5);
		    void *val = (void*)temp;
		    newID->type = "nstr";
		    newID->value = val;
		    nowType = -1;
		    if(existed == 0){
		      Insert(Top(SymbolTables)->table, newID);
		    }
		  }
		  else if(nowType == 3){
		    char *temp = strdup($5);
		    void *val = (void*)temp;
		    newID->type = "nbool";
		    newID->value = val;
		    nowType = -1;
		    if(existed == 0){
		      Insert(Top(SymbolTables)->table, newID);
		    }
		  }
		  else{
		    printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		    nowType = -1;
		  }
		  Dump(Top(SymbolTables)->table);
		}
		|
		LET MUT IDENTIFIER
		{
		  Trace("Reducing to variable declaration w/ no type and initial value\n");
		  if(Search(Top(SymbolTables)->table, $3) == NULL){
		    ID *newID = CreateID($3);
		    
		    Insert(Top(SymbolTables)->table, newID);
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("Error: %s already exists!\n", $3);
		  }
		}
		;

array_declar:	LET MUT IDENTIFIER SBRACKETSL type COMMA NUMBER SBRACKETSR
		{
		  Trace("Reducing to array declaration w/ type and # of elements\n");
		  ID * newID = Search(Top(SymbolTables)->table, $3);
		  int existed = 1;

		  if(newID == NULL){
		    newID = CreateID($3);
		    existed = 0;
		  }
		  int *temp = (int*)malloc(sizeof(int));
		  *temp = atoi($7);

		  void *val = (void*)temp;
		  char *stemp = strdup($5);
		  strcat(stemp, "_array");
		  newID->type = stemp;
		  newID->value = val;
		  if(existed == 0){
		    Insert(Top(SymbolTables)->table, newID);
		  }
		  Dump(Top(SymbolTables)->table);
		}
		;

func_declar:	FN IDENTIFIER PARENTHESESL func_argument PARENTHESESR MINUS LARGERT type block
		{
		  Trace("Reducing to function declaration w/ arguments and return type\n");
		  ID * newID = Search(Top(SymbolTables)->table, $2);

		  if(newID == NULL){
		    newID = CreateID($2);
		    newID->type = strdup("Function_");
		    strcat(newID->type, $8);
		    Insert(Top(SymbolTables)->table, newID);
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("%s already existed!\n", $2);
		  }
		}
		|
		FN IDENTIFIER PARENTHESESL PARENTHESESR MINUS LARGERT type block
		{
		  Trace("Reducing to function declaration w/ return type\n");
		  ID * newID = Search(Top(SymbolTables)->table, $2);

		  if(newID == NULL){
		    newID = CreateID($2);
		    newID->type = strdup("Function_");
		    strcat(newID->type, $7);
		    Insert(Top(SymbolTables)->table, newID);
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("%s already existed!\n", $2);
		  }
		}
		|
		FN IDENTIFIER PARENTHESESL PARENTHESESR block
		{
		  Trace("Reducing to function declaration w/ no arguments and no return type\n");
		  ID * newID = Search(Top(SymbolTables)->table, $2);

		  if(newID == NULL){
		    newID = CreateID($2);
		    newID->type = strdup("Function");
		    Insert(Top(SymbolTables)->table, newID);
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("%s already existed!\n", $2);
		  }
		}
		|
		FN IDENTIFIER PARENTHESESL func_argument PARENTHESESR block
		{
		  Trace("Reducing to function declaration w/ arguments\n");
		  ID * newID = Search(Top(SymbolTables)->table, $2);

		  if(newID == NULL){
		    newID = CreateID($2);
		    newID->type = strdup("Function");
		    Insert(Top(SymbolTables)->table, newID);
		    Dump(Top(SymbolTables)->table);
		  }
		  else{
		    printf("%s already existed!\n", $2);
		  }
		}
		;

func_argument:	func_argument COMMA IDENTIFIER COLON type
		|
		IDENTIFIER COLON type
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

simple_stmt:	IDENTIFIER ASSIGN expr
		{
		  Trace("Reducing to simple statement\n");
		  ID *newID = Search(Top(SymbolTables)->table, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		  }
		  else{
		    switch(nowType){
		      case 0:
		        if(newID->type == NULL || strcmp("int", newID->type) == 0 || strcmp("nint", newID->type) == 0){
			  int* temp = (int*)malloc(sizeof(int));
			  *temp = atoi($3);
			  newID->value = (void*)temp;
			}
			else{
			  printf("Error: Unsuitable type\n");
			}
		        break;
		      case 1:
		        if(newID->type == NULL || strcmp("float", newID->type) == 0 || strcmp("nfloat", newID->type) == 0){
			  float* temp = (float*)malloc(sizeof(float));
			  *temp = atof($3);
			  newID->value = (void*)temp;
			}
			else{
			  printf("Error: Unsuitable type\n");
			}
		        break;
		      case 2:
		        if(newID->type == NULL || strcmp("str", newID->type) == 0 || strcmp("nstr", newID->type) == 0){
			  newID->value = (void*)$3;
			}
			else{
			  printf("Error: Unsuitable type\n");
			}
		        break;
		      case 3:
		        if(newID->type == NULL || strcmp("bool", newID->type) == 0 || strcmp("nbool", newID->type) == 0){
			  newID->value = (void*)$3;
			}
			else{
			  printf("Error: Unsuitable type\n");
			}
		        break;
		      default:
			printf("Error: Undefined type\n");
		        break;
		    }
		  }
		}
		|
		array_ref ASSIGN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		PRINT expr
		{
		  Trace("Reducing to simple statement\n");
		  if(nowType == 0){
		    printf("%d", atoi($2));
		  }
		  else if(nowType == 1){
		    printf("%f", atof($2));
		  }
		  else{
		    printf("%s", $2);
		  }
		}
		|
		PRINTLN expr
		{
		  Trace("Reducing to simple statement\n");
		  if(nowType == 0){
		    printf("%d\n", atoi($2));
		  }
		  else if(nowType == 1){
		    printf("%f\n", atof($2));
		  }
		  else{
		    printf("%s\n", $2);
		  }
		}
		|
		READ IDENTIFIER
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
		  $$ = $1;
		}
		|
		boolean_expr
		{
		  Trace("Reducing to expression\n");
		  $$ = $1;
		}
		|
		constant_expr
		{
		  Trace("Reducing to expression\n");
		  $$ = $1;
		}
		|
		IDENTIFIER
		{
		  Trace("Reducing to expression\n");
		  ID *newID = Search(Top(SymbolTables)->table, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		  }
		  else{
		    if(newID->type == NULL){
		      $$ = strdup("0");
		      nowType = 0;
		    }
		    else if(strcmp(newID->type, "int") == 0 ||strcmp(newID->type, "nint") == 0){
		      sprintf($$, "%d", *(int*)newID->value);
		      nowType = 0;
		    }
		    else if(strcmp(newID->type, "float") == 0 ||strcmp(newID->type, "nfloat") == 0){
		      sprintf($$, "%f", *(float*)newID->value);
		      nowType = 1;
		    }
		    else if(strcmp(newID->type, "str") == 0 ||strcmp(newID->type, "nstr") == 0){
		      $$ = (char*)newID->value;
		      nowType = 2;
		    }
		    else if(strcmp(newID->type, "bool") == 0 ||strcmp(newID->type, "nbool") == 0){
		      $$ = (char*)newID->value;
		      nowType = 3;
		    }
		    else{
		      printf("Error: Can't print type %s variable\n", newID->type);
		    }
		  }
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
		{
		  printf("Reducing to integer expression\n");
		  if(nowType == 0){
		    sprintf($$, "%d", (atoi($1) + atoi($3)));
		    nowType = 0;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (atof($1) + atof($3)));
		    nowType = 1;
		  }
		}
		|
		integer_expr MINUS integer_expr
		{
		  printf("Reducing to integer expression\n");
		  if(nowType == 0){
		    sprintf($$, "%d", (atoi($1) - atoi($3)));
		    nowType = 0;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (atof($1) - atof($3)));
		    nowType = 1;
		  }
		}
		|
		integer_expr MULTIPLY integer_expr
		{
		  printf("Reducing to integer expression\n");
		  if(nowType == 0){
		    sprintf($$, "%d", (atoi($1) * atoi($3)));
		    nowType = 0;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (atof($1) * atof($3)));
		    nowType = 1;
		  }
		}
		|
		integer_expr DIVIDE integer_expr
		{
		  if(nowType == 0){
		    sprintf($$, "%d", atoi($1) / atoi($3));
		    nowType = 1;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (atof($1) / atof($3)));
		    nowType = 1;
		  }
		}
		|
		MINUS integer_expr %prec UMINUS
		{
		  printf("Reducing to integer expression\n");
		  if(nowType == 0){
		    sprintf($$, "%d", (int)(atoi($2) * -1));
		    nowType = 0;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (float)((atof($2) * -1)));
		    nowType = 1;
		  }
		}
		|
		NUMBER
		{
		  $$ = $1;
		  nowType = 0;
		}
		|
		REALNUMBER
		{
		  $$ = $1;
		  nowType = 1;
		}
		|
		IDENTIFIER
		{
		  /*printf("%s\n", $1);
		  ID *newID = Search(Top(SymbolTables)->table, $1);
		  if(newID == NULL){
			  if(newID->type == "int" ||newID->type == "nint"){
			    sprintf($$, "%d", *(int*)newID->value);
			    nowType = 0;
			  }
			  else if(newID->type == "float" || newID->type == "nfloat"){
			    sprintf($$, "%f", *(float*)newID->value);
			    nowType = 0;
			  }
			  else{
			    printf("Error: the type is not a real number\n");
			  }
		  }
		  else{
		    printf("Error: %s doesn't exist\n", $1);
		    $$ = strdup("0");
		  }
*/
		}
		;

boolean_expr:	boolean_expr AND boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr OR boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		NOT boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		boolean_expr LESST boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr LESSE boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr LARGERT boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr LARGERE boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr EQUAL boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		boolean_expr NEQUAL boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		TRUE
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		FALSE		
		{
		  printf("Reducing to boolean expression\n");
		}
		|
		IDENTIFIER
		{
		  printf("Reducing to boolean expression\n");
		  $$ = $1;
		}
		|
		NUMBER
		{
		  printf("Reducing to boolean expression\n");
		  $$ = $1;
		}
		|
		REALNUMBER
		{
		  printf("Reducing to boolean expression\n");
		  $$ = $1;
		}
		;

array_ref:	IDENTIFIER SBRACKETSL integer_expr SBRACKETSR
		{
		  Trace("Reducing to array reference\n");
		}
		;

func_invoke:	IDENTIFIER PARENTHESESL func_invoke_arg PARENTHESESR
		{
		  Trace("Reducing to function invocation\n");
		  $$ = strdup("0");
		  nowType = 0;
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

type:		INT
		{
		  $$ = "int";
		}
		|
		STR
		{
		  $$ = "str";
		}
		|
		BOOL
		{
		  $$ = "bool";
		}
		|
		FLOAT
		{
		  $$ = "float";
		}
		;

constant_expr:	NUMBER
		{
		  $$ = $1;
		  nowType = 0;
		}
		|
		REALNUMBER
		{
		  $$ = $1;
		  nowType = 1;
		}
		|
		STRING
		{
		  $$ = $1;
		  nowType = 2;
		}
		|
		FALSE
		{
		  $$ = $1;
		  nowType = 3;
		}
		|
		TRUE
		{
		  $$ = $1;
		  nowType = 3;
		}
		;
%%
#include "lex.yy.c"

IDstk *SymbolTables = NULL;
int nowType = -1;

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

