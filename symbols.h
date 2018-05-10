#ifndef SYMBOLS
#define SYMBOLS
typedef struct Id{
  char *name;
  struct Id *next;
}ID;

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
#endif
