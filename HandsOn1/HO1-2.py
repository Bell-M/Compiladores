def validate_real(s):
    try:
        float(s)
        return True
    except ValueError:
        return False
input_str = "-123.456"
if validate_real(input_str):
    print("Número válido.")
else:
    print("Número inválido.")