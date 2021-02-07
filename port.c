#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct cat {
    struct cat *prev;
    char name[];
    struct obj;
    struct cat *next;
}cat;


typedef struct obj {
    struct obj *prev;
    char name[];
    struct obj *next;
}obj;

void newcat (char d[], cat **i) {
    if (*i==NULL) {
        printf("Insertando %s en la lista \n" ,d);
        *i = (cat*)malloc(sizeof(cat));
        strcpy((*i)->name, d);
        (*i)->sgte = NULL;
    }

int main()
{
    
}




//strcpy(dest, src);