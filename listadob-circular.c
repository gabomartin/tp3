#include <stdio.h>

typedef struct nodo{
    int dato;
    struct nodo* nextCategory;
    struct nodo* prevCategory;
}nodo;

nodo* primero = NULL;
nodo* ultimo = NULL;

void newNode(); // nodo nuevo

void mostrarListaPU(); // del primero al ult
void mostrarListaUP(); // del ult al primero

void delNode(); // eliminar nodo

int main(){

    int opcionMenu = 0;
	do{
		printf("1. Insertar nodo\n");
        printf("2. Eliminar nodo\n");
        printf("3. Mostrar PU\n");
        printf("4. Mostrar UP\n");
        printf("5. Salir\n");
		printf("\n\nA continuacion, elija su opcion: ");
		scanf("%d", &opcionMenu);

        switch(opcionMenu){
			case 1:
				printf("\n\nInsertar nodo en la lista\n\n");
				newNode();
				break;

			case 2:
				printf("\n\nEliminar nodo de la lista\n\n");
				delNode();
				break;
			case 3:
				printf("\n\nObjetos de la lista del primero al ultimo\n\n");
				mostrarListaPU();
				break;
			case 4:
				printf("\n\nObjetos de la lista del ultimo al primero\n\n");
				mostrarListaUP();
				break;
			case 5:
				printf("\n\nEl programa ha finalizado.\n");
				break;
			default:
				printf("\n\nLa opcion no es valida.\n\n");
		}
	}while(opcionMenu != 5);

    return 0;
}

void newNode(){ // nodo nuevo
    nodo* newCategory = (nodo*)malloc(sizeof(nodo));
    printf("Ingresar dato del nodo:\n");
    scanf("%d", &newCategory->dato);

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
printf("Nodo ingresado\n\n");

}

void mostrarListaPU(){ // muestra la lista desde el primero al ultimo
    nodo* actual = (nodo*)malloc(sizeof(nodo));
    actual = primero;
    if (primero != NULL){
        do{
            printf("%d\n\n\n", actual->dato);
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
            printf("%d\n\n\n", actual->dato);
            actual = actual->prevCategory;
        }while(actual != ultimo);

    }else{
        printf("La lista esta vacia.\n");
    }
}

void delNode() // eliminar nodo
{
    nodo* actual = (nodo*) malloc(sizeof(nodo));
	actual = primero;
	nodo* anterior = (nodo*) malloc(sizeof(nodo));
	anterior = NULL;
	int nodoBuscado = 0, encontrado = 0;
	printf("Ingresar dato del nodo a buscar para eliminarlo: ");
	scanf("%d", &nodoBuscado);
	if(primero!=NULL){
		do{
			if(actual->dato == nodoBuscado){
				printf("\nNodo con el dato %d encontrado\n", nodoBuscado);

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
