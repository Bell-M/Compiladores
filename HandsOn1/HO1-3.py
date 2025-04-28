def validate_if_else(s):
    return "if" in s and "else" in s
input_str = "if x > 0: pass else: pass"
if validate_if_else(input_str):
    print("Sentencia válida.")
else:
    print("Sentencia inválida.")