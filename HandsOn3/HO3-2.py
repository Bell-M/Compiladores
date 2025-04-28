import re

class LogicalParser:
    def __init__(self, input_string):
        self.tokens = re.findall(r'AND|OR|NOT|\(|\)|0|1', input_string)
        self.position = 0

    def parse(self):
        if self.expr() and self.position == len(self.tokens):
            return True
        return False

    def expr(self):
        if not self.term():
            return False
        while self.current_token() in ('AND', 'OR'):
            self.advance()
            if not self.term():
                return False
        return True

    def term(self):
        if self.current_token() == 'NOT':
            self.advance()
            return self.factor()
        else:
            return self.factor()

    def factor(self):
        token = self.current_token()
        if token == '(':
            self.advance()
            if not self.expr():
                return False
            if self.current_token() != ')':
                return False
            self.advance()
            return True
        elif token in ('0', '1'):
            self.advance()
            return True
        else:
            return False

    def current_token(self):
        if self.position < len(self.tokens):
            return self.tokens[self.position]
        return None

    def advance(self):
        self.position += 1


def validar_expresion_logica(expresion):
    parser = LogicalParser(expresion)
    if parser.parse():
        print("Expresión válida")
    else:
        print("Expresión inválida")

validar_expresion_logica("(1 AND 0) OR (NOT 1)")  
validar_expresion_logica("(1 AND (0 OR 1)")      