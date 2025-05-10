%{
#include <stdio.h>      // Para printf
#include <stdlib.h>     // Para malloc, free, etc.
#include <string.h>     // Para strcmp
int yylex(void);        // Función léxica
int yyerror(char *s) { printf("Error: %s\n", s); return 0; } // Errores sintácticos

#define MAX_ID 100

char *tabla[MAX_ID];    // Nombres de variables
int tipos[MAX_ID];      // Tipo de cada variable
int ntabla = 0;         // Número de variables registradas

void agregar_tipo(char *id, int tipo) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) return; // Ya existe, no agregar de nuevo
    }
    tabla[ntabla] = strdup(id);   // Copia el nombre
    tipos[ntabla++] = tipo;       // Guarda el tipo
}

int buscar_tipo(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) return tipos[i]; // Devuelve el tipo
    }
    return -1; // No encontrado
}

int existe(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i], id) == 0) return 1; // Existe
    }
    return 0; // No existe
}
%}

%union { char *str; }         // Definición de tipos de valores semánticos
%token <str> ID
%token INT IGUAL PUNTOYCOMA

%%

// Reglas de producción
programa:
    declaraciones asignaciones
;

declaraciones:
    INT ID PUNTOYCOMA { agregar_tipo($2, 0); }
  | declaraciones INT ID PUNTOYCOMA { agregar_tipo($3, 0); }
;

asignaciones:
    ID IGUAL ID PUNTOYCOMA {
        if (!existe($1) || !existe($3))
            printf("Error: identificador no declarado\n");
        else if (buscar_tipo($1) != buscar_tipo($3))
            printf("Error: tipos incompatibles\n");
    }
  | asignaciones ID IGUAL ID PUNTOYCOMA {
        if (!existe($2) || !existe($4))
            printf("Error: identificador no declarado\n");
        else if (buscar_tipo($2) != buscar_tipo($4))
            printf("Error: tipos incompatibles\n");
    }
;

%%

int main() {
    return yyparse();
}
