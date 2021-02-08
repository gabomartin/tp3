#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAX 16

typedef struct obj{                       //objetos de categoria
    char objeto[MAX];
    struct obj* nextObject;
    struct obj* prevObject;
}obj;

obj* head = NULL;  //primero
obj* tail = NULL;  //ultimo

typedef struct nodo{                      //categorias
    char cat[MAX];
	struct obj* first;                     // apunta a otra lista que contiene los elementos de dicha categoria
    struct nodo* nextCategory;
    struct nodo* prevCategory;
}nodo;

nodo* primero = NULL;
nodo* ultimo = NULL;


void newCat(); // categoria nueva
void newObj(); //nuevo objeto

void mostrarListaPU(); // del primero al ult
void mostrarListaUP(); // del ult al primero

void delCat(); // eliminar nodo

int main(){

    int opcionMenu = 0;
	do{
		printf("1. Insertar categoria\n");
        printf("2. Eliminar categoria\n");
        printf("3. Mostrar PU\n");
        printf("4. Mostrar UP\n");
		printf("5. Insertar objeto\n");
        printf("10. Salir\n");
		printf("\n\nA continuacion, elija su opcion: ");
		scanf("%d", &opcionMenu);

        switch(opcionMenu){
			case 1:
				printf("\n\nInsertar categoria en la lista\n\n");
				newCat();
				break;

			case 2:
				printf("\n\nEliminar categoria de la lista\n\n");
				delCat();
				break;
			case 3:
				printf("\n\nCat. de la lista del primero al ultimo\n\n");
				mostrarListaPU();
				break;
			case 4:
				printf("\n\nCat. de la lista del ultimo al primero\n\n");
				mostrarListaUP();
				break;
			case 5:
				printf("\n\nInsertar objeto\n\n");
				newObj();
				break;
			case 10:
				printf("\n\nEl programa ha finalizado.\n");
				break;
			default:
				printf("\n\nLa opcion no es valida.\n\n");
		}
	}while(opcionMenu != 10);

    return 0;
}

void newCat(){ // nodo nuevo
    nodo* newCategory = (nodo*)malloc(sizeof(nodo));
    printf("Ingresar categoria del nodo:\n");
    scanf("%s", &newCategory->cat);

    if(primero == NULL){
        primero = newCategory;
        primero->nextCategory = primero;
        ultimo = primero;
        primero->prevCategory = ultimo;
    }else{
        ultimo->nextCategory = newCategory;
        newCategory->nextCategory = primero;
        newCategory->prevCategory = ultimo;
        ultimo = newCategory;
        primero->prevCategory = ultimo;
    }
printf("Categoria ingresada\n\n");

}

void mostrarListaPU(){ // muestra la lista desde el primero al ultimo
    nodo* actual = (nodo*)malloc(sizeof(nodo));
    actual = primero;
    if (primero != NULL){
        do{
            printf("%s\n\n\n", actual->cat);
            actual = actual->nextCategory;
        }while(actual != primero);

    }else{
        printf("La lista esta vacia.\n");
    }
}

void mostrarListaUP(){ // muestra la lista desde el ultimo al primero
    nodo* actual = (nodo*)malloc(sizeof(nodo));
    actual = ultimo;
    if (primero != NULL){
        do{
            printf("%s\n\n\n", actual->cat);
            actual = actual->prevCategory;
        }while(actual != ultimo);

    }else{
        printf("La lista esta vacia.\n");
    }
}

void delCat() // eliminar nodo
{
    nodo* actual = (nodo*) malloc(sizeof(nodo));
	actual = primero;
	nodo* anterior = (nodo*) malloc(sizeof(nodo));
	anterior = NULL;
	char nodoBuscado[MAX];
	int encontrado = 0;
	printf("Ingresar categoria del nodo a buscar para eliminarlo: ");
	scanf("%s", &nodoBuscado);
	if(primero!=NULL){
		do{
			//if(actual->cat == nodoBuscado){   
			if(strcmp(actual->cat, nodoBuscado)==0){
				printf("\nNodo con el categoria %s encontrado\n", nodoBuscado);

				if(actual==primero){
					primero = primero->nextCategory;
					primero->prevCategory = ultimo;
					ultimo->nextCategory = primero;
				}else if(actual==ultimo){
					ultimo = anterior;
					ultimo->nextCategory = primero;
					primero->prevCategory = ultimo;
				}else{
					anterior->nextCategory = actual->nextCategory;
					actual->nextCategory->prevCategory = anterior;
				}
				printf("\nNodo eliminado\n\n");
				encontrado = 1;
			}
			anterior = actual;
			actual = actual->nextCategory;
		}while(actual != primero && encontrado != 1);
		if(encontrado == 0){
			printf("\nNodo no encontrado\n\n");
		}else{
			free(anterior);
		}
	}else{
		printf("\nLa lista esta vacia.\n\n");
	}
}

// hay que implementar un selector de categorias para despues agregar objetos a la seleccionada (working class)




void newObj(){ // obj nuevo
    nodo* actual = (nodo*) malloc(sizeof(nodo));
	actual = primero;
    char catBuscada[MAX];
	int encontrado = 0;
    printf("Ingresar categoria a ingresar objeto:\n");
    scanf("%s", &catBuscada);                                   //crashea dsp de esto
    do{
    if(strcmp(actual->cat, catBuscada)==0)
	    {
			printf("\nNodo con el categoria %s encontrado\n", catBuscada);
			encontrado = 1;
            
	        obj* newObj = (obj*)malloc(sizeof(obj));
            printf("Ingresar objeto:\n");
            scanf("%s", &newObj->objeto);

            if(head == NULL){
             head = newObj;
             head->nextObject = head;
             tail = head;
             head->prevObject = tail;
		     obj* first =  head;   ///quiero indicar el primer objeto de la categoria!!
            }else
			{
             tail->nextObject = newObj;
             newObj->nextObject = head;
             newObj->prevObject = tail;
             tail = newObj;
             head->prevObject = tail;
            }
          printf("Objeto ingresado\n\n");
        }      
		actual = actual->nextCategory;
	}while(actual != primero && encontrado != 1); 
          if(encontrado == 0)
		  {
			printf("\nCategoria no encontrada\n\n");           
          }
    
}