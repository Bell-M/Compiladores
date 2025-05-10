%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(char *s) { printf("Error: %s\n", s); return 0; }

#define MAX_SIMB 200

typedef struct {
    char *nombre;   // Nombre del identificador
    int tipo;       // 0 = variable, 1 = función
    int aridad;     // Número de argumentos (si es función)
    int ambito;     // Nivel de ámbito
} Simbolo;

Simbolo tabla[MAX_SIMB];
int ntabla = 0;
int ambito_actual = 0;

void entrar_ambito() {
    ambito_actual++;
}

void salir_ambito() {
    for (int i = 0; i < ntabla; i++) {
        if (tabla[i].ambito == ambito_actual) {
            tabla[i].nombre[0] = '\0'; // Marca como eliminado
        }
    }
    ambito_actual--;
}

void agregar_variable(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == ambito_actual) {
            printf("Error: redeclaración de '%s'\n", id);
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){strdup(id), 0, 0, ambito_actual};
}

void agregar_funcion(char *id, int aridad) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].ambito == 0 && tabla[i].tipo == 1) {
            printf("Error: función '%s' ya declarada\n", id);
            return;
        }
    }
    tabla[ntabla++] = (Simbolo){strdup(id), 1, aridad, 0};
}

int buscar_variable(char *id) {
    for (int a = ambito_actual; a >= 0; a--) {
        for (int i = 0; i < ntabla; i++) {
            if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].tipo == 0 && tabla[i].ambito == a) {
                return 1;
            }
        }
    }
    return 0;
}

int buscar_funcion(char *id) {
    for (int i = 0; i < ntabla; i++) {
        if (strcmp(tabla[i].nombre, id) == 0 && tabla[i].tipo == 1) {
            return tabla[i].aridad;
        }
    }
    return -1;
}

%}

%union { char *str; int num; }

%token <str> ID
%token INT FUNC RETURN IGUAL
%token PARIZQ PARDER LLAVEIZQ LLAVEDER PUNTOYCOMA COMA

%%

programa:
    declaraciones
;

declaraciones:
    declaracion
    | declaraciones declaracion
;

declaracion:
    INT ID PUNTOYCOMA                         { agregar_variable($2); }
    | FUNC ID PARIZQ parametros PARDER bloque  { agregar_funcion($2, $4); }
;

parametros:
    /* vacío */                                { $$ = 0; }
    | lista_param                              { $$ = $1; }
;

lista_param:
    ID                                         { agregar_variable($1); $$ = 1; }
    | lista_param COMA ID                      { agregar_variable($3); $$ = $1 + 1; }
;

bloque:
    LLAVEIZQ { entrar_ambito(); } instrucciones LLAVEDER { salir_ambito(); }
;

instrucciones:
    instruccion
    | instrucciones instruccion
;

instruccion:
    INT ID PUNTOYCOMA                          { agregar_variable($2); }
    | ID IGUAL ID PUNTOYCOMA                   {
        if (!buscar_variable($1) || !buscar_variable($3))
            printf("Error: identificador no declarado\n");
    }
    | ID PARIZQ argumentos PARDER PUNTOYCOMA    {
        int esperados = buscar_funcion($1);
        if (esperados == -1)
            printf("Error: función '%s' no declarada\n", $1);
        else if (esperados != $3)
            printf("Error: función '%s' espera %d argumentos\n", $1, esperados);
    }
    | RETURN ID PUNTOYCOMA                     {
        if (!buscar_variable($2))
            printf("Error: identificador no declarado\n");
    }
    | bloque
;

argumentos:
    /* vacío */                                { $$ = 0; }
    | lista_args                               { $$ = $1; }
;

lista_args:
    ID                                         {
        if (!buscar_variable($1))
            printf("Error: identificador no declarado\n");
        $$ = 1;
    }
    | lista_args COMA ID                       {
        if (!buscar_variable($3))
            printf("Error: identificador no declarado\n");
        $$ = $1 + 1;
    }
;

%%

int main() {
    return yyparse();
}
