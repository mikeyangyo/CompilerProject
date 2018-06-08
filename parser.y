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
		  Dump(Top(SymbolTables)->table, Top(SymbolTables)->tableName);
                }
		|
		normal_declars
                {
                  Trace("Reducing to program\n");
		  Dump(Top(SymbolTables)->table, Top(SymbolTables)->tableName);
                }
		|
		func_declars
                {
                  Trace("Reducing to program\n");
		  Dump(Top(SymbolTables)->table, Top(SymbolTables)->tableName);
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

		      if(Top(SymbolTables)->tableName == 1){
			printtab(tabNum);
			fprintf(Instructions, "field static int %s = %s\n", $3, $7);
			newID->globalORlocal = 0;
		      }
		      else{
			printtab(tabNum);
			fprintf(Instructions, "sipush %s\n", $7);
			printtab(tabNum);
			fprintf(Instructions, "istore %d\n", nowStkIndex);
			newID->stkIndex = nowStkIndex;
			nowStkIndex++;
			newID->globalORlocal = 1;
		      }

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

		      if(Top(SymbolTables)->tableName == 1){
			printtab(tabNum);
			fprintf(Instructions, "field static int %s = %d\n", $3, (strcmp($7, "true")==0?1:0));
			newID->globalORlocal = 0;
		      }
		      else{
			printtab(tabNum);
			fprintf(Instructions, "sipush %d\n", (strcmp($7, "true")==0?1:0));
			printtab(tabNum);
			fprintf(Instructions, "istore %d\n", nowStkIndex);
			newID->stkIndex = nowStkIndex;
			nowStkIndex++;
			newID->globalORlocal = 1;
		      }

		      if(existed == 0){
			Insert(Top(SymbolTables)->table, newID);
		      }
		    }
		  }
		  else{
		    printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		    nowType = -1;
		  }		  
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

		  if(Top(SymbolTables)->tableName == 1){
		    printtab(tabNum);
		    fprintf(Instructions, "field static int %s\n", $3);
		    newID->globalORlocal = 0;
		  }
		  else{
		    newID->stkIndex = nowStkIndex;
		    nowStkIndex++;
		    newID->globalORlocal = 1;
		  }

		  if(existed == 0){
		    Insert(Top(SymbolTables)->table, newID);
		  }
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

		    if(Top(SymbolTables)->tableName == 1){
		      printtab(tabNum);
		      fprintf(Instructions, "field static int %s = %s\n", $3, $5);
		      newID->globalORlocal = 0;
		    }
		    else{
		     printtab(tabNum);
		     fprintf(Instructions, "sipush %s\n", $5);
		     printtab(tabNum);
		     fprintf(Instructions, "istore %d\n", nowStkIndex);
		     newID->stkIndex = nowStkIndex;
		     nowStkIndex++;
		     newID->globalORlocal = 1;
		    }

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

		    if(Top(SymbolTables)->tableName == 1){
		      printtab(tabNum);
		      fprintf(Instructions, "field static int %s = %d\n", $3, (strcmp($5, "true")==0?1:0));
		      newID->globalORlocal = 0;
		    }
		    else{
		      printtab(tabNum);
		      fprintf(Instructions, "sipush %d\n", (strcmp($5, "true")==0?1:0));
		      printtab(tabNum);
		      fprintf(Instructions, "istore %d\n", nowStkIndex);
		      newID->stkIndex = nowStkIndex;
		      nowStkIndex++;
		      newID->globalORlocal = 1;
		    }

		    if(existed == 0){
		      Insert(Top(SymbolTables)->table, newID);
		    }
		  }
		  else{
		    printf("Error: nowType is out of range [0,3]\n, nowType = %d", nowType);
		    nowType = -1;
		  }
		}
		|
		LET MUT IDENTIFIER
		{
		  Trace("Reducing to variable declaration w/ no type and initial value\n");
		  if(Search(Top(SymbolTables)->table, $3) == NULL){
		    ID *newID = CreateID($3);

		    if(Top(SymbolTables)->tableName == 1){
		      printtab(tabNum);
		      fprintf(Instructions, "field static int %s\n", $3);
		      newID->globalORlocal = 0;
		    }
		    else{
		      newID->stkIndex = nowStkIndex;
		      nowStkIndex++;
		      newID->globalORlocal = 1;
		    }

		    Insert(Top(SymbolTables)->table, newID);
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
		}
		;

func_declar:	FN
		{
		  printtab(tabNum);
		  fprintf(Instructions, "method public static");
		  IDstk *newTable = stkCreate();
		  stkInsert(SymbolTables, newTable);
		  inFuncBlock = 1;
		}
		func_body block
		{
		  Trace("Reducing to function declaration w/ arguments and return type\n");
		  if(returned == 0){
		    printtab(tabNum);
     		    fprintf(Instructions, "return\n");
		  }
		  tabNum--;
		  printtab(tabNum);
		  fprintf(Instructions, "}\n");
		  inFuncBlock = 0;
		  argumentsStr = NULL;
		  returned = 0;
		  nowStkIndex = 0;
		}
		;

arguments:	func_argument
		|
		;

func_body:	IDENTIFIER PARENTHESESL arguments PARENTHESESR MINUS LARGERT type 
		{
		  ID *newID = Search(Top(SymbolTables)->table, $1);

		  if(newID == NULL){
		    newID = CreateID($1);
		    newID->type = strdup("Function");
		    Insert(SymbolTables->table, newID);
		  }
		  else{
		    printf("%s already existed!\n", $1);
		  }
		  newID->argumentsTypeList = argumentsStr;
		  newID->returnType = strdup($7);
		  if(strcmp($1, "main") != 0){
		    if(argumentsStr == NULL){
		      fprintf(Instructions, " %s %s()\n", $7, $1);
		    }
		    else{
		      fprintf(Instructions, " %s %s(%s)\n", $7, $1, argumentsStr);
		    }
		  }
		  else{
  		    fprintf(Instructions, " %s %s(java.lang.String[])\n", $7, $1);
		  }
  		  printtab(tabNum);
		  fprintf(Instructions, "max_stack 15\n");
  		  printtab(tabNum);
		  fprintf(Instructions, "max_locals 15\n");
  		  printtab(tabNum);
		  fprintf(Instructions, "{\n");
		  tabNum++;
		}
		|
		IDENTIFIER PARENTHESESL arguments PARENTHESESR
		{
		  ID *newID = Search(Top(SymbolTables)->table, $1);

		  if(newID == NULL){
		    newID = CreateID($1);
		    newID->type = strdup("Function");
		    Insert(SymbolTables->table, newID);
		  }
		  else{
		    printf("%s already existed!\n", $1);
		  }
		  newID->argumentsTypeList = argumentsStr;
		  newID->returnType = strdup("void");
		  if(strcmp($1, "main") != 0){
		    if(argumentsStr == NULL){
		      fprintf(Instructions, " void %s()\n", $1);
		    }
		    else{
		      fprintf(Instructions, " void %s(%s)\n", $1, argumentsStr);
		    }
		  }
		  else{
  		    fprintf(Instructions, " void %s(java.lang.String[])\n", $1);
		  }
		  printtab(tabNum);
		  fprintf(Instructions, "max_stack 15\n");
		  printtab(tabNum);
		  fprintf(Instructions, "max_locals 15\n");
		  printtab(tabNum);
		  fprintf(Instructions, "{\n");
		  tabNum++;
		}
		;

func_argument:	func_argument COMMA IDENTIFIER COLON type
		{
		  ID *newID = Search(Top(SymbolTables)->table, $3);
		  if(newID == NULL){
		    newID = CreateID($3);
		    newID->type = $5;
		    newID->stkIndex = nowStkIndex;
		    nowStkIndex++;
		    newID->globalORlocal = 1;
		    Insert(Top(SymbolTables)->table, newID);
		  }
		  strcat(argumentsStr, ", ");
		  strcat(argumentsStr, $5);
		}
		|
		IDENTIFIER COLON type
		{
		  ID *newID = Search(Top(SymbolTables)->table, $1);
		  if(newID == NULL){
		    newID = CreateID($1);
		    newID->type = $3;
		    newID->stkIndex = nowStkIndex;
		    nowStkIndex++;
		    newID->globalORlocal = 1;
		    Insert(Top(SymbolTables)->table, newID);
		  }

		  argumentsStr = strdup($3);
		}
		;

block:		cl normal_declars stmts CBRACKETSR
		{
		  Trace("Reducing to block w/ normal declaration and statements\n");
		  Dump(Top(SymbolTables)->table, Top(SymbolTables)->tableName);
		  Pop(SymbolTables);
		  inFuncBlock = 0;
		}
		|
		cl stmts CBRACKETSR
		{
		  Trace("Reducing to block w/ statements\n");
		  Dump(Top(SymbolTables)->table, Top(SymbolTables)->tableName);
		  Pop(SymbolTables);
		  inFuncBlock = 0;
		}
		;

cl:		CBRACKETSL
		{
		  if(inFuncBlock == 0){
		    IDstk *newTable = stkCreate();
		    stkInsert(SymbolTables, newTable);
		  }
		  inFuncBlock = 0;
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
		  Trace("Reducing to statements1\n");
		}
		|
		conditional
		{
		  Trace("Reducing to statements2\n");
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
		  ID *newID = stkSearch(SymbolTables, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		    exit(1);
		  }
		  if(newID->globalORlocal == 1){
		    printtab(tabNum);
		    fprintf(Instructions, "istore %d\n", newID->stkIndex);
		  }
		  else if(newID->globalORlocal == 0){
		    printtab(tabNum);
		    fprintf(Instructions, "putstatic int project3.%s\n", newID->name);
		  }
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
		|
		array_ref ASSIGN expr
		{
		  Trace("Reducing to simple statement\n");
		}
		|
		PRINT
		{
		  printtab(tabNum);
  		  fprintf(Instructions, "getstatic java.io.PrintStream java.lang.System.out\n");
		}
		expr
		{
		  Trace("Reducing to simple statement\n");
		  if(nowType == 2){
		    printtab(tabNum);
		    fprintf(Instructions, "invokevirtual void java.io.PrintStream.print(java.lang.String)\n");
		  }
		  else{
		    printtab(tabNum);
		    fprintf(Instructions, "invokevirtual void java.io.PrintStream.print(int)\n");
		  }
		}
		|
		PRINTLN
		{
		  printtab(tabNum);
  		  fprintf(Instructions, "getstatic java.io.PrintStream java.lang.System.out\n");
		}
		expr
		{
		  Trace("Reducing to simple statement\n");
		  if(nowType == 2){
		    printtab(tabNum);
		    fprintf(Instructions, "invokevirtual void java.io.PrintStream.println(java.lang.String)\n");
		  }
		  else{
		    printtab(tabNum);
		    fprintf(Instructions, "invokevirtual void java.io.PrintStream.println(int)\n");
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
		  printtab(tabNum);
		  fprintf(Instructions, "return\n");
		  returned = 1;
		}
		|
		RETURN expr
		{
		  Trace("Reducing to simple statement\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ireturn\n");
		  returned = 1;
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
		  Trace("Reducing to expression1\n");
		  ID *newID = stkSearch(SymbolTables, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		    exit(1);
		  }
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
		  if(newID->globalORlocal == 0){
		    printtab(tabNum);
		    fprintf(Instructions, "getstatic int project3.%s\n", newID->name);
		  }
		  else{
		    printtab(tabNum);
		    fprintf(Instructions, "iload %d\n", newID->stkIndex);
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
		  printtab(tabNum);
		  fprintf(Instructions, "iadd\n");
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
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
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
		  printtab(tabNum);
		  fprintf(Instructions, "imul\n");
		}
		|
		integer_expr DIVIDE integer_expr
		{
/*
		  if(nowType == 0){
		    sprintf($$, "%d", atoi($1) / atoi($3));
		    nowType = 1;
		  }
		  else if(nowType == 1){
		    sprintf($$, "%f", (atof($1) / atof($3)));
		    nowType = 1;
		  }*/
		  printtab(tabNum);
		  fprintf(Instructions, "idiv\n");
		}
		|
		integer_expr MOD integer_expr
		{
		  printtab(tabNum);
		  fprintf(Instructions, "irem\n");
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
		  printtab(tabNum);
		  fprintf(Instructions, "ineg\n");
		}
		|
		NUMBER
		{
		  printtab(tabNum);
		  fprintf(Instructions, "sipush %d\n", atoi($1));
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
		  ID *newID = stkSearch(SymbolTables, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		    exit(1);
		  }
		  if(newID->globalORlocal == 0){
		    printtab(tabNum);
  		    fprintf(Instructions, "getstatic int project3.%s\n", newID->name);
		  }
		  else{
		    printtab(tabNum);
		    fprintf(Instructions, "iload %d\n", newID->stkIndex);
		  }
		}
		;

boolean_expr:	boolean_expr AND boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "iand\n");
		}
		|
		boolean_expr OR boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ior\n");
		}
		|
		NOT boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ixor\n");
		}
		|
		boolean_expr LESST boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "iflt L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		boolean_expr LESSE boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ifle L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		boolean_expr LARGERT boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ifgt L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		boolean_expr LARGERE boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ifge L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		boolean_expr EQUAL boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ifeq L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		boolean_expr NEQUAL boolean_expr
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "isub\n");
		  printtab(tabNum);
		  fprintf(Instructions, "ifne L%d\n", nowLabel++);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		|
		TRUE
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_1\n");
		}
		|
		FALSE		
		{
		  printf("Reducing to boolean expression\n");
		  printtab(tabNum);
		  fprintf(Instructions, "iconst_0\n");
		}
		|
		IDENTIFIER
		{
		  printf("Reducing to boolean expression\n");
		  ID *newID = stkSearch(SymbolTables, $1);
		  if(newID == NULL){
		    printf("Error: Undefined variable\n");
		    exit(1);
		  }
		  if(newID->globalORlocal == 0){
  		    printtab(tabNum);
  		    fprintf(Instructions, "getstatic int project3.%s\n", newID->name);
		  }
		  else{
  		    printtab(tabNum);
		    fprintf(Instructions, "iload %d\n", newID->stkIndex);
		  }

		  $$ = $1;
		}
		|
		NUMBER
		{
		  printf("Reducing to boolean expression\n");
  		  printtab(tabNum);
		  fprintf(Instructions, "sipush %d\n", atoi($1));
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
		  ID *newID = Search(SymbolTables->table, $1);
		  if(newID == NULL){
		    printf("Function doesn't exist\n");
		    exit(1);
		  }
		  Trace("Reducing to function invocation\n");
		  $$ = strdup("0");
		  nowType = 0;
  		  printtab(tabNum);
		  fprintf(Instructions, "invokestatic %s project3.%s(%s)\n", newID->returnType, $1, newID->argumentsTypeList);
		}
		;

func_invoke_arg:func_invoke_arg COMMA expr
		|
		expr
		;

conditional:	IF PARENTHESESL boolean_expr PARENTHESESR
		{
  		  printtab(tabNum);
		  fprintf(Instructions, "ifeq L%d\n", nowLabel++);
		}
		block
		{
  		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel++);
		  fprintf(Instructions, "L%d:\n", nowLabel-2);
		}
		conditional_else
		{
  		  fprintf(Instructions, "L%d:\n", nowLabel-1);
		}
		;

conditional_else:ELSE block
		|
		;

loop:		WHILE
		{
		  fprintf(Instructions, "L%d:\n", nowLabel++);
		}
		PARENTHESESL boolean_expr PARENTHESESR
		{
  		  printtab(tabNum);
		  fprintf(Instructions, "ifeq L%d\n", nowLabel++);
		}
		block
		{
		  Trace("Reducing to loop\n");
  		  printtab(tabNum);
		  fprintf(Instructions, "goto L%d\n", nowLabel-4);
		  fprintf(Instructions, "L%d:\n", nowLabel-1);
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
  		  printtab(tabNum);
		  fprintf(Instructions, "ldc \"%s\"\n", $1);
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
int nowStkIndex = 0;
int inFuncBlock = 0;
int returned = 0;
int nowLabel = 0;
int tabNum = 1;
FILE *Instructions;
char *argumentsStr = NULL;
yyerror(msg)
char *msg;
{
    fprintf(stderr, "%s\n", msg);
}

main(int argc, char **argv)
{
    Instructions = fopen("./instructions.jasm", "w+");
    fprintf(Instructions, "class project3\n{\n");
    nowTableName = 0;
    /* open the source program file */
    if (argc != 2) {
        printf ("Usage: sc filename\n");
        exit(1);
    }
    yyin = fopen(argv[1], "r");         /* open input file */

    SymbolTables = stkCreate();


    /* perform parsing */
    if (yyparse() == 1)                 /* parsing */
        yyerror("Parsing error !");     /* syntax error */
    tabNum--;
    fprintf(Instructions, "}\n");
    fclose(Instructions);
}

void printtab(int num){
  for(int i = 0; i < num; i++){
    fprintf(Instructions, "\t");
  }
}
