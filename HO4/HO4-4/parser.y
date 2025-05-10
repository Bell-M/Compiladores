%{
#include <stdio.h>   // Para impresión en consola
#include <stdlib.h>  // Para memoria dinámica
#include <string.h>  // Para manejo de cadenas

int yylex(void);  // Declaración de la función léxica
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }  // Manejo de errores sintácticos

#define MAX_SCOPE 10
#define MAX_ID 100

char *ambitos[MAX_SCOPE][MAX_ID];  // Tabla de símbolos para múltiples niveles de ámbito
int niveles[MAX_SCOPE];             // Cantidad de variables por cada nivel
int tope = 0;                       // Índice del ámbito actual

void entrar_ambito() {
    tope++;               // Entrar a un nuevo ámbito
    niveles[tope] = 0;    // Inicializar el contador de variables del nuevo ámbito
}

void salir_ambito() {
    tope--;               // Salir del ámbito actual
}

void agregar_local(char *id) {
    ambitos[tope][niveles[tope]++] = strdup(id);  // Guardar la variable en el ámbito actual
}

int buscar_local(char *id) {
    for (int i = tope; i >= 0; i--) {             // Buscar desde el ámbito actual hacia arriba
        for (int j = 0; j < niveles[i]; j++) {
            if (strcmp(ambitos[i][j], id) == 0) {
                return 1;  // Encontrado
            }
        }
    }
    return 0;  // No encontrado
}
%}

%union { char *str; }  // Asociación de tipo de valor semántico

%token <str> ID
%token INT LLAVEIZQ LLAVEDER PUNTOYCOMA

%%

programa:
    bloque
    ;

bloque:
    LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
    ;

instrucciones:
    instruccion
    | instrucciones instruccion
    ;

instruccion:
    INT ID PUNTOYCOMA           { agregar_local($2); }
    | ID PUNTOYCOMA              {
                                    if (!buscar_local($1))
                                        printf("Error semántico: '%s' no está declarado\n", $1);
                                 }
    | bloque
    ;

%%

int main() {
    return yyparse();  // Punto de entrada principal
}