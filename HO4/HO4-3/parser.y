%{
#include <stdio.h>   // Para printf
#include <stdlib.h>  // Para malloc, free
#include <string.h>  // Para strcmp, strdup

// Declaración de la función léxica
int yylex(void);

// Función para manejo de errores
int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

// Definiciones para la tabla de funciones
#define MAX_FUNC 100
char *funciones[MAX_FUNC];  // Nombres de funciones
int aridades[MAX_FUNC];     // Número de argumentos esperados por función
int nfuncs = 0;             // Número de funciones registradas

// Función para registrar una función
void registrar_funcion(char *id, int n) {
    funciones[nfuncs] = strdup(id);
    aridades[nfuncs++] = n;
}

// Función para obtener la aridad de una función
int obtener_aridad(char *id) {
    for (int i = 0; i < nfuncs; i++) {
        if (strcmp(funciones[i], id) == 0)
            return aridades[i];
    }
    return -1; // Si no se encuentra
}
%}

// Definición de tipo de valores asociados a los tokens
%union { char *str; int num; }

// Definición de tokens
%token <str> ID
%token FUNC PARIZQ PARDER PUNTOYCOMA COMA

%type <num> lista args


%%

// Regla principal
programa:
    declaraciones llamadas
;

// Declaración de funciones
declaraciones:
    FUNC ID PARIZQ lista PARDER PUNTOYCOMA { registrar_funcion($2, $4); }
  | declaraciones FUNC ID PARIZQ lista PARDER PUNTOYCOMA { registrar_funcion($3, $5); }
;

// Lista de parámetros
lista:
    ID { $$ = 1; }                         // Un parámetro
  | lista COMA ID { $$ = $1 + 1; }         // Más de un parámetro
;

// Llamadas a funciones
llamadas:
    ID PARIZQ args PARDER PUNTOYCOMA {
        int n = obtener_aridad($1);
        if (n != $3)
            printf("Error: se esperaban %d argumentos en '%s'\n", n, $1);
    }
  | llamadas ID PARIZQ args PARDER PUNTOYCOMA {
        int n = obtener_aridad($2);
        if (n != $4)
            printf("Error: se esperaban %d argumentos en '%s'\n", n, $2);
    }
;

// Lista de argumentos en las llamadas
args:
    ID { $$ = 1; }                         // Un argumento
  | args COMA ID { $$ = $1 + 1; }          // Más de un argumento
  | { $$ = 0; }                            // Sin argumentos
;

%%

// Función principal
int main() {
    return yyparse();
}
