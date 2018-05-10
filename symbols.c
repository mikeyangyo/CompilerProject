#include"symbols.h"
#include<stdio.h>
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

int Insert(ID *givenList, ID *newID){
  ID *current = givenList;
  int i = 0;
  while(current->next != NULL){
    current = current->next;
    i++;
  }
  current->next = newID;
  return i;
}

int Dump(ID* givenList){
  ID *current = givenList;
  printf("\nSymbol Table:\n");
  while(current->next != NULL){
    printf("%s\n", current->name);
    current = current->next;
  }
  printf("%s\n", current->name);
}

int Search(ID *givenList, char *sname){
  ID *current = givenList;
  int i = 0;
  while(current->next != NULL){
    if(strcmp(current->name, sname) == 0){
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
