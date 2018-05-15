#ifndef SYMBOLS
#define SYMBOLS
typedef struct Id{
  char *name;
  char *type;
  int int_bool_val;
  float real_number_val;
  char *str_val;
  struct Id *next;
}ID;

typedef struct stk{
  struct Id *table;
  struct stk *next;
}IDstk;

// create an ID with newName
ID* CreateID(char *newName);
// create an ID-list
ID* Create();
// insert an newID in linked-list
int Insert(ID *givenList, ID *newID);
// dump the link
int Dump(ID *givenList);
// search where the ID with sname is
int Search(ID *givenList, char *sname);

// create a stk
IDstk* stkCreate();
// return top of stk
ID* top(IDstk* givenSTK);
// pop the top of stk
void pop(IDstk* givenSTK);
#endif
