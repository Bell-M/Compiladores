%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
"int"                     { return INT; }                     // Palabra clave int
[a-zA-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return ID; } // Identificador
";"                       { return PUNTOYCOMA; }             // Punto y coma
[ \t\n]+                  ;                                  // Ignorar espacios y saltos de línea
.                         { return yytext[0]; }              // Cualquier otro carácter
%%
