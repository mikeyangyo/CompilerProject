%{
  #include "symbols.h"
  #include "y.tab.h"
  #define MAX_LINE_LENG 256
  #define LIST strcat(buf,yytext)
  #define token(t) {LIST;}
  #define tokensk(t) {LIST;}
  #define tokenInteger(t,i) {LIST;}
  #define tokenString(t,s) {LIST;}
  
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
number [-]?[0-9][0-9]*
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
{fn} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp); return(FN);}
{println} { char* temp = malloc(7); toUpper(yytext, temp); tokensk(temp); return(PRINTLN);}
{bool} { char* temp = malloc(4); tokensk(temp); yylval.sval = yytext; return(BOOL);}
{break} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(BREAK);}
{char} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp); return(CHAR);}
{continue} { char* temp = malloc(8); toUpper(yytext, temp); tokensk(temp); return(CONTINUE);}
{do} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp); return(DO);}
{else} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp); return(ELSE);}
{enum} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp); return(ENUM);}
{extern} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp); return(EXTERN);}
{float} { char* temp = malloc(5); tokensk(temp); yylval.sval = yytext;return(FLOAT);}
{for} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp); return(FOR);}
{if} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp); return(IF);}
{in} { char* temp = malloc(2); toUpper(yytext, temp); tokensk(temp); return(IN);}
{int} { char* temp = malloc(3); tokensk(temp); yylval.sval = yytext;return(INT);}
{let} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp); return(LET);}
{loop} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp); return(LOOP);}
{match} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(MATCH);}
{mut} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp); return(MUT);}
{print} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(PRINT);}
{pub} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp); return(PUB);}
{return} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(RETURN);}
{self} { char* temp = malloc(4); toUpper(yytext, temp); tokensk(temp); return(SELF);}
{static} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp); return(STATIC);}
{str} { char* temp = malloc(3); tokensk(temp); yylval.sval = yytext;return(STR);}
{struct} { char* temp = malloc(6); toUpper(yytext, temp); tokensk(temp); return(STRUCT);}
{use} { char* temp = malloc(3); toUpper(yytext, temp); tokensk(temp); return(USE);}
{where} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(WHERE);}
{while} { char* temp = malloc(5); toUpper(yytext, temp); tokensk(temp); return(WHILE);}
{true} { char* temp = malloc(4); tokensk(temp); yylval.sval = yytext; return(TRUE);}
{false} { char* temp = malloc(5); tokensk(temp); yylval.sval = yytext;return(FALSE);}
{identifier} {
	       tokenString("id", yytext);
	       yylval.sval = strdup(yytext);
	       return(IDENTIFIER);
	     }
{comma} {token(yytext); return(COMMA);}
{colon} {token(yytext); return(COLON);}
{semicolon} {token(yytext); return(SEMICOLON);}
{parenthesesL} {token(yytext); return(PARENTHESESL);}
{parenthesesR} {token(yytext); return(PARENTHESESR);}
{sbracketsL} {token(yytext); return(SBRACKETSL);}
{sbracketsR} {token(yytext); return(SBRACKETSR);}
{cbracketsL} {token(yytext); return(CBRACKETSL);}
{cbracketsR} {token(yytext); return(CBRACKETSR);}
{plus} {token(yytext); printf("+\n");return(PLUS);}
{minus} {token(yytext); return(MINUS);}
{multiply} {token(yytext); return(MULTIPLY);}
{divide} {token(yytext); return(DIVIDE);}
{dplus} {token(yytext); return(DPLUS);}
{dminus} {token(yytext); return(DMINUS);}
{mod} {token(yytext); return(MOD);}
{lessT} {token(yytext); return(LESST);}
{lessE} {token(yytext); return(LESSE);}
{largerT} {token(yytext); return(LARGERT);}
{largerE} {token(yytext); return(LARGERE);}
{equal} {token(yytext); return(EQUAL);}
{nequal} {token(yytext); return(NEQUAL);}
{and} {token(yytext); return(AND);}
{or} {token(yytext); return(OR);}
{not} {token(yytext); return(NOT);}
{assign} {token(yytext); return(ASSIGN);}
{plusE} {token(yytext); return(PLUSE);}
{minusE} {token(yytext); return(MINUSE);}
{multiplyE} {token(yytext); return(MULTIPLYE);}
{divideE} {token(yytext); return(DIVIDEE);}
{number} {tokenInteger("integer", atoi(yytext)); yylval.sval = yytext; printf("%s\n", yytext);return(NUMBER);}
{realnumber} {tokenString("real number", yytext); yylval.sval = yytext; return(REALNUMBER);}

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
      yytext = strdup(result);
      strcat(buf, "\"");
      //tokenString("string", "");
      yylval.sval = yytext;
      return(STRING);
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
