%{
#include "parser.tab.h"  // Inclusión del encabezado generado por Bison
#include <string.h>      // Para manejo de cadenas
#include <stdlib.h>      // Para asignación dinámica
%}

%%
"int"               { return INT; }  // Palabra clave int
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }  // Identificadores
";"                 { return PUNTOYCOMA; }  // Punto y coma
"{"                 { return LLAVEIZQ; }    // Llave izquierda
"}"                 { return LLAVEDER; }    // Llave derecha
[ \t\n\r]+          ;  // Ignorar espacios en blanco y saltos de línea
.                   { return yytext[0]; }  // Cualquier otro carácter literal
%%

