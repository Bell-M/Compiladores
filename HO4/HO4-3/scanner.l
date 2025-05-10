%{
#include "parser.tab.h" // Incluye los tokens definidos por Bison
#include <string.h>
#include <stdlib.h>
%}
%%
"func" { return FUNC; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
"(" { return PARIZQ; }
")" { return PARDER; }
";" { return PUNTOYCOMA; }
"," { return COMA; }
[ \t\n]+ ; // Ignorar espacios y saltos de línea
. { return yytext[0]; } // Cualquier otro carácter
%%
