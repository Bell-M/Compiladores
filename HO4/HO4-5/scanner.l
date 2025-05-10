%{
#include "parser.tab.h"  // Inclusión del archivo de tokens generado por Bison
#include <string.h>      // Para strdup
#include <stdlib.h>      // Para malloc, free
%}

%%

"int"           { return INT; }          // Palabra clave para enteros
"func"          { return FUNC; }         // Palabra clave para funciones
"return"        { return RETURN; }       // Palabra clave para return

[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }  // Identificador

"("             { return PARIZQ; }       // Paréntesis izquierdo
")"             { return PARDER; }       // Paréntesis derecho
"{"             { return LLAVEIZQ; }     // Llave izquierda
"}"             { return LLAVEDER; }     // Llave derecha
";"             { return PUNTOYCOMA; }   // Punto y coma
","             { return COMA; }         // Coma
"="             { return IGUAL; }        // Operador de asignación

[ \t\n]+        ;                        // Ignorar espacios y saltos de línea

.               { return yytext[0]; }    // Cualquier otro carácter literal

%%

