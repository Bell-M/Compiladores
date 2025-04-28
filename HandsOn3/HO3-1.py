import re

class Parser:
    def __init__(self, input_string):
        self.tokens = re.findall(r'\d+|[()+\-*/]', input_string.replace(' ', ''))
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
        elif self.is_number(token):
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

    def is_number(self, token):
        return token is not None and token.isdigit()


def validar_expresion(expresion):
    parser = Parser(expresion)
    if parser.parse():
        print("Expresión válida")
    else:
        print("Expresión inválida")

validar_expresion("(4 + 5) * 2")  
validar_expresion("3 - (2 + )")    