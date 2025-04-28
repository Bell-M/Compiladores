import ply.lex as lex

tokens = [
    'IDENTIFICADOR', 'NUMERO', 'PALABRA_CLAVE'
]

t_lignore = ' \t'

def t_PALABRA_CLAVE(t):
    r'int|return'
    return t

def t_IDENTIFICADOR(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    return t

def t_NUMERO(t):
    r'\d+'
    t.value = int(t.value)
    return t

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

def t_error(t):
    print(f"Caracter inesperado: {t.value[0]}")
    t.lexer.skip(1)

lexer = lex.lex()