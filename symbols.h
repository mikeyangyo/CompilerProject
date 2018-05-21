#ifndef SYMBOLS
#define SYMBOLS
typedef struct Id{
  char *name;
  char *type;
  void *value;
  struct Id *next;
}ID;

typedef struct stk{
  char *tableName;
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
int Dump(ID *givenList, char *tableName);
// search where the ID with sname is
ID* Search(ID *givenList, char *sname);
// print id value
void printval(ID *nowID);
// create a stk
IDstk* stkCreate(char *tableName);
// return top of stk
IDstk* Top(IDstk *givenSTK);
// pop the top of stk
void Pop(IDstk *givenSTK);
// insert the table into stk
void stkInsert(IDstk *givenSTK, IDstk *newTable);
#endif
