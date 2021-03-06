#include"symbols.h"
#include<stdio.h>
ID* CreateID(char *newName){
  ID *newID = NULL;
  newID = (ID*)malloc(sizeof(ID));
  newID->name = newName;
  newID->type = NULL;
  newID->variableType = -1;
  newID->value = NULL;
  newID->stkIndex = -1;
  newID->globalORlocal = -1;
  newID->next = NULL;
  newID->argumentsTypeList = NULL;
  newID->returnType = NULL;
  return newID;
}

ID* Create(){
  return (ID*)malloc(sizeof(ID));
}

int Insert(ID *givenList, ID *newID){
  ID *current = givenList;
  int i = 0;
  if(current->name == NULL && current->next == NULL){
    current->name = newID->name;
    current->type = newID->type;
    current->value = newID->value;
    current->stkIndex = newID->stkIndex;
    current->next = newID->next;
    current->globalORlocal = newID->globalORlocal;
    current->argumentsTypeList = newID->argumentsTypeList;
    current->returnType = newID->returnType;
    current->variableType = newID->variableType;
    return 0;
  }
  while(current->next != NULL){
    current = current->next;
    i++;
  }
  current->next = newID;
  return i;
}

int Dump(ID *givenList, int name){
  ID *current = givenList;
  printf("\nSymbol Table %d:\n", name);
  while(current->next != NULL){
    printval(current);
    current = current->next;
  }
  printval(current);
  printf("\n");
}

ID* Search(ID *givenList, char *sname){
  ID *current = givenList;

  if(current->name == NULL){
    return NULL;
  }

  while(current->next != NULL){
    if(strcmp(current->name, sname) == 0){
      return current;
    }
    current = current->next;
  }

  if(strcmp(current->name, sname) == 0){
    return current;
  }

  return NULL;
}

// print id value
void printval(ID *nowID){
  if(nowID->type == NULL){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else if(strcmp(nowID->type, "int") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%d\n", nowID->name, nowID->type, *((int*)nowID->value));
  }
  else if(strcmp(nowID->type, "nint") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%d\n", nowID->name, NULL, *((int*)nowID->value));
  }
  else if(strcmp(nowID->type, "str") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, (char*)nowID->value);
  }
  else if(strcmp(nowID->type, "nstr") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%s\n", nowID->name, NULL, (char*)nowID->value);
  }
  else if(strcmp(nowID->type, "float") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%2f\n", nowID->name, nowID->type, *((float*)nowID->value));
  }
  else if(strcmp(nowID->type, "nfloat") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%2f\n", nowID->name, NULL, *((float*)nowID->value));
  }
  else if(strcmp(nowID->type, "bool") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, (char*)nowID->value);
  }
  else if(strcmp(nowID->type, "nbool") == 0){
    if(nowID->value == NULL){
      printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
      return;
    }
    printf("%s\t\t%s\t\t%s\n", nowID->name, NULL, (char*)nowID->value);
  }
  else if(strcmp(nowID->type, "int_array") == 0){
    printf("%s\t\t%s\t\t%d\n", nowID->name, nowID->type, *(int*)nowID->value);
  }
  else if(strcmp(nowID->type, "str_array") == 0){
    printf("%s\t\t%s\t\t%d\n", nowID->name, nowID->type, *(int*)nowID->value);
  }
  else if(strcmp(nowID->type, "float_array") == 0){
    printf("%s\t\t%s\t\t%d\n", nowID->name, nowID->type, *(int*)nowID->value);
  }
  else if(strcmp(nowID->type, "bool_array") == 0){
    printf("%s\t\t%s\t\t%d\n", nowID->name, nowID->type, *(int*)nowID->value);
  }
  else if(strcmp(nowID->type, "Function") == 0){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else if(strcmp(nowID->type, "Function_int") == 0){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else if(strcmp(nowID->type, "Function_float") == 0){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else if(strcmp(nowID->type, "Function_str") == 0){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else if(strcmp(nowID->type, "Function_float") == 0){
    printf("%s\t\t%s\t\t%s\n", nowID->name, nowID->type, nowID->value);
  }
  else{
    printf("Error: ID type is wrong, type = %s\n", nowID->type);
  }
}

IDstk* stkCreate(){
  IDstk* newSTK = (IDstk*)malloc(sizeof(IDstk));
  nowTableName++;
  newSTK->tableName = nowTableName;
  newSTK->table = Create();
  newSTK->next = NULL;
  return newSTK;
}
// return top of stk
IDstk* Top(IDstk* givenSTK){
  IDstk *nowstk = givenSTK;
  while(nowstk->next != NULL){
    nowstk = nowstk->next;
  }
  if(nowstk->table != NULL){
    return nowstk;
  }
  return NULL;
}
// pop the top of stk
void Pop(IDstk* givenSTK){
  IDstk *nowstk = givenSTK;
  IDstk *newstk = givenSTK;
  int i = 0;
  while(nowstk->next != NULL){
    nowstk = nowstk->next;
    i++;
  }
  for(i = i-1;i>0;i--){
    newstk = newstk->next;
  }
  newstk->next = NULL;
}
// insert the table into stk
void stkInsert(IDstk *givenSTK, IDstk *newTable){
  IDstk *nowtop = Top(givenSTK);
  nowtop->next = newTable;
}

ID* stkSearch(IDstk *givenSTK, char *name){
  IDstk *current = givenSTK;
  ID *result = NULL;
  ID *existed;
  while(current->next != NULL){
    printf("now seeking tablename = %d\n", current->tableName);
    existed = Search(current->table, name);
    if(existed != NULL){
      result = existed;
    }
    current = current->next;
  }
  printf("now seeking tablename = %d\n", current->tableName);
  existed = Search(current->table, name);
  if(existed != NULL){
    result = existed;
  }
  return result;
}

