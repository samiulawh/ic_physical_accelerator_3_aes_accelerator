import sympy as sp

x = sp.Symbol("x")

dividend = x**8 + x**4 + x**3 + x + 1  # inside
divisor =  x + 1   # outside

quotient, remainder = sp.div(dividend, divisor, domain=sp.GF(2))

print("Quotient: ", quotient)
print("Remainder: ", remainder)

# gives coefficients from the polynomial
coefficients = sp.Poly(quotient, x).all_coeffs()
coefficients = [int(c) % 2 for c in coefficients]

# Pad with leading zeros to ensure it is exactly 8 bits long
while len(coefficients) < 8:
    coefficients.insert(0, 0)

print("coefficients: ", coefficients)

# string representation of bits into a base-2 integer
binary_val = int(''.join(map(str, coefficients)), 2)
print("Inverse (Hex): ", hex(binary_val))

def circular_left_shift(number, shift_amount):
    # circular shift and mask with 0xFF to keep within 8 bits
    result = ((number << shift_amount) | (number >> (8 - shift_amount))) & 0xFF
    return result

# 4 circular left shifts for Affine Transformation
shifted1 = circular_left_shift(binary_val, 1)
shifted2 = circular_left_shift(binary_val, 2)
shifted3 = circular_left_shift(binary_val, 3)
shifted4 = circular_left_shift(binary_val, 4)

final_sbox_val = binary_val ^ shifted1 ^ shifted2 ^ shifted3 ^ shifted4 ^ 0x63

print("Final S-Box Value (Hex): ", hex(final_sbox_val))