import re

class ComplexParser:
    def __init__(self, input_string):
        self.tokens = re.findall(r'AND|OR|NOT|\d+|[()+\-*/]', input_string.replace(' ', ''))
        self.position = 0

    def parse(self):
        if self.expr() and self.position == len(self.tokens):
            return True
        return False

    def expr(self):
        if not self.term():
            return False
        while self.current_token() in ('+', '-'):
            self.advance()
            if not self.term():
                return False
        return True

    def term(self):
        if not self.factor():
            return False
        while self.current_token() in ('*', '/'):
            self.advance()
            if not self.factor():
                return False
        return True

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
        else:
            return self.logical()

    def logical(self):
        if self.current_token() == 'NOT':
            self.advance()
            return self.logical()
        elif self.is_bool(self.current_token()):
            self.advance()
            while self.current_token() in ('AND', 'OR'):
                self.advance()
                if not self.logical():
                    return False
            return True
        return False

    def is_bool(self, token):
        return token is not None and token.isdigit()

    def current_token(self):
        if self.position < len(self.tokens):
            return self.tokens[self.position]
        return None

    def advance(self):
        self.position += 1

def validar_expresion_compleja(expresion):
    parser = ComplexParser(expresion)
    if parser.parse():
        print("Expresión válida")
    else:
        print("Expresión inválida")

validar_expresion_compleja("(4 + 5) * (2 AND 1)")  
validar_expresion_compleja("(2 AND 3) / (4 - 1")   