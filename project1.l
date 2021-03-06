%{
  #define MAX_LINE_LENG 256
  #define LIST strcat(buf,yytext)
  #define token(t) {LIST; printf("<'%s'>\n",t);}
  #define tokensk(t) {LIST; printf("<%s>\n", t);}
  #define tokenInteger(t,i) {LIST; printf("<%s: %d>\n",t,i);}
  #define tokenString(t,s) {LIST; printf("<%s: %s>\n",t,s);}
  typedef struct Id{
    char *name;
    struct Id *next;
  }ID;
  
  ID *SymbolTable;
  int num_of_Line = 1;
  int begining = 1;
  char c;
  char buf[MAX_LINE_LENG];
  char strbuf[MAX_LINE_LENG];

  ID* CreateID(char *newName){
    ID *newID = NULL;
    newID = (ID*)malloc(sizeof(ID));
    newID->name = newName;
    newID->next = NULL;
    return newID;
  }
  ID* Create(){
    return (ID*)malloc(sizeof(ID));
  }

  int Insert(ID *newID){
    ID *current = SymbolTable;
    while(current->next != NULL){
      current = current->next;
    }
    current->next = newID;
  }

  int Dump(){
    ID *current = SymbolTable;
    printf("\nSymbol Table:\n");
    while(current->next != NULL){
      printf("%s\n", current->name);
      current = current->next;
    }
    printf("%s\n", current->name);
  }
  
  int Search(char *sname){
    ID *current = SymbolTable;
    int i = 0;
    if((current->name, sname) == 0){
      Dump();
      return 0;
    }
    while(current->next != NULL){
      if(strcmp(current->name,sname) == 0){
        return i;
      }
      i++;
      current = current->next;
    }
    if(strcmp(current->name, sname) == 0){
      return i;
    }
    return -1;
  }

  int toUpper(char* s, char* result){
    int i = 0;
    memset(result, '\0', 10);
    strcpy(result, s);
    while(result[i] != '\0')
    {
      result[i] = result[i] - 'a' + 'A';
      i++;
    }
    return 0;
  }
%}
keywords "f""n"|"p""r""i""n""t""l""n"|"b""o""o""l"|"b""r""e""a""k"|"c""h""a""r"|"c""o""n""t""i""n""u""e"|"d""o"|"e""l""s""e"|"e""n""u""m"|"e""x""t""e""r""n"|"f""l""o""a""t"|"f""o""r"|"i""f"|"i""n"|"i""n""t"|"l""e""t"|"l""o""o""p"|"m""a""t""c""h"|"m""u""t"|"p""r""i""n""t"|"p""u""b"|"r""e""t""u""r""n"|"s""e""l""f"|"s""t""a""t""i""c"|"s""t""r"|"s""t""r""u""c""t"|"u""s""e"|"w""h""e""r""e"|"w""h""i""l""e"
identifier [a-zA-Z_][a-zA-Z_0-9]*
number [+-]?[0-9][0-9]*
realnumber [+-]?[0-9][0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
delimiter ","|":"|";"|"("|")"|"{"|"}"|"["|"]"
operator "+"|"-"|"*"|"/"|"+""+"|"-""-"|"%"|"<"|"<""="|">""="|">"|"=""="|"!""="|"&""&"|"|""|"|"!"|"="|"+""="|"-""="|"*""="|"/""="
boolean "t""r""u""e"|"f""a""l""s""e"
%%
{keywords} { char* temp = malloc(10); toUpper(yytext, temp); tokensk(temp);}
{boolean} {char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{identifier} {
	       tokenString("id", yytext);
	       char *cpystr = NULL;
	       cpystr = (char*)malloc(yyleng);
	       strcpy(cpystr, yytext);
	       ID* newID = NULL;
	       newID = (ID*)malloc(sizeof(ID));
               newID = CreateID(cpystr);
	       int i = 0;
	       if(begining == 1){
	         SymbolTable = newID;
		 begining = 0;
	       }
	       else{
		 if((i = Search(newID->name)) == -1){
		   Insert(newID);
		 }
	       }
	     }
{delimiter} {token(yytext);}
{operator} {token(yytext);}
{number} {tokenInteger("integer", atoi(yytext));}
{realnumber} {tokenString("real number", yytext);}

"\"" {
      char *result = malloc(MAX_LINE_LENG);
      strcat(buf, "\"");
      memset(strbuf, '\0', MAX_LINE_LENG);
      memset(result, '\0', MAX_LINE_LENG);
      int i = 0;
      while(c = input()){
	if(c == '\"'){
	  c = input();
          if (c != '\"'){
	    unput(c);
	    strcat(buf, strbuf);
	    strcat(result, strbuf);
	    break;
          }
          strcat(buf, strbuf);
	  strcat(buf, "\"");
	  strcat(result, strbuf);
	  memset(strbuf, '\0', MAX_LINE_LENG);
          i = 0;
        }
        strbuf[i] = c;
	i++;
      }
      tokenString("string", result);
    }

"//" { 
      memset(strbuf, '\0', MAX_LINE_LENG);
      int i = 2;
      strbuf[0] = '/';
      strbuf[1] = '/';
      while(c = input()){
        if(c == '\n'){
          unput('\n');
          break;
        }
        strbuf[i] = c;
	i++;
      }
      strcat(buf, strbuf);
    }
"/*" {
      memset(strbuf, '\0', MAX_LINE_LENG);
      int i = 2;
      strbuf[0] = '/';
      strbuf[1] = '*';
      while(c = input()){
        if(c == '\n'){
	  i = 0;
          strcpy(buf, strbuf);
	  printf("%d: %s\n", num_of_Line, buf);
	  num_of_Line++;
	  memset(buf, '\0', MAX_LINE_LENG);
	  memset(strbuf, '\0', MAX_LINE_LENG);  
        }
        else if(c == '*'){
	  strbuf[i] = c;
	  i++;
	  c = input();
          if(c == '/'){
	    strbuf[i] = c;
	    strcpy(buf, strbuf);
	    break;
          }
	  unput(c);
	}
	else{
	  strbuf[i] = c;
	  i++;
	}
      }
    }

\n {
     LIST;
     printf("%d: %s", num_of_Line, buf);
     num_of_Line++;
     buf[0] = '\0';
   }
[ \t]* {LIST;}

. {
    LIST;
    printf("%d:%s\n", num_of_Line, buf);
    printf("bad character:’%s’\n",yytext);
    exit(-1);
  }
%%
int main()
{
  SymbolTable = Create();
  yylex();
  Dump(SymbolTable);
}
