%{
  #include "symbols.h"
  #define MAX_LINE_LENG 256
  #define LIST strcat(buf,yytext)
  #define token(t) {LIST; printf("<'%s'>\n",t); return(t);}
  #define tokensk(t) {LIST; printf("<%s>\n", t); return(t);}
  #define tokenInteger(t,i) {LIST; printf("<%s: %d>\n",t,i); return(t);}
  #define tokenString(t,s) {LIST; printf("<%s: %s>\n",t,s); return(t);}
  
  ID *SymbolTable;
  int num_of_Line = 1;
  int begining = 1;
  char c;
  char buf[MAX_LINE_LENG];
  char strbuf[MAX_LINE_LENG];

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
fn "f""n"
println "p""r""i""n""t""l""n"
bool "b""o""o""l"
break "b""r""e""a""k"
char "c""h""a""r"
continue "c""o""n""t""i""n""u""e"
do "d""o"
else "e""l""s""e"
enum "e""n""u""m"
extern "e""x""t""e""r""n"
float "f""l""o""a""t"
for "f""o""r"
if "i""f"
in "i""n"
int "i""n""t"
let "l""e""t"
loop "l""o""o""p"
match "m""a""t""c""h"
mut "m""u""t"
print "p""r""i""n""t"
pub "p""u""b"
return "r""e""t""u""r""n"
self "s""e""l""f"
static "s""t""a""t""i""c"
str "s""t""r"
struct "s""t""r""u""c""t"
use "u""s""e"
where "w""h""e""r""e"
while "w""h""i""l""e"
true "t""r""u""e"
false "f""a""l""s""e"
identifier [a-zA-Z_][a-zA-Z_0-9]*
number [+-]?[0-9][0-9]*
realnumber [+-]?[0-9][0-9]*\.[0-9]+([eE][+-]?[0-9]+)?
comma ","
colon ":"
semicolon ";"
parenthesesL "("
parenthesesR ")"
sbracketsL "["
sbracketsR "]"
cbracketsL "{"
cbracketsR "}"
plus "+"
minus "-"
multiply "*"
divide "/"
dplus "+""+"
dminus "-""-"
mod "%"
lessT "<"
lessE "<""="
largerT ">"
largerE ">""="
equal "=""="
nequal "!""="
and "&""&"
or "|""|"
not "!"
assign "="
plusE "+""="
minusE "-""="
multiplyE "*""="
divideE "/""="
%%
{fn} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp);}
{println} { char* temp = malloc(7); toUpper(yytext, temp); tokensk(temp);}
{bool} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{break} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{char} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{continue} { char* temp = malloc(8); toUpper(yytext, temp); tokensk(temp);}
{do} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp);}
{else} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{enum} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{extern} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp);}
{float} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{for} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{if} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp);}
{in} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp);}
{int} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{let} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{loop} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{match} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{mut} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{print} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{pub} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{return} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{self} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{static} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp);}
{str} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{struct} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp);}
{use} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp);}
{where} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{while} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
{true} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp);}
{false} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp);}
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
		 if((i = Search(SymbolTable, newID->name)) == -1){
		   Insert(SymbolTable, newID);
		 }
	       }
	     }
{comma} {token(yytext);}
{colon} {token(yytext);}
{semicolon} {token(yytext);}
{parenthesesL} {token(yytext);}
{parenthesesR} {token(yytext);}
{sbracketsL} {token(yytext);}
{sbracketsR} {token(yytext);}
{cbracketsL} {token(yytext);}
{cbracketsR} {token(yytext);}
{plus} {token(yytext);}
{minus} {token(yytext);}
{multiply} {token(yytext);}
{divide} {token(yytext);}
{dplus} {token(yytext);}
{dminus} {token(yytext);}
{mod} {token(yytext);}
{lessT} {token(yytext);}
{lessE} {token(yytext);}
{largerT} {token(yytext);}
{largerE} {token(yytext);}
{equal} {token(yytext);}
{nequal} {token(yytext);}
{and} {token(yytext);}
{or} {token(yytext);}
{not} {token(yytext);}
{assign} {token(yytext);}
{plusE} {token(yytext);}
{minusE} {token(yytext);}
{multiplyE} {token(yytext);}
{divideE} {token(yytext);}
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
