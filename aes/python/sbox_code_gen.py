def gf_multiply(a, b):
    """Galois Field GF(2^8) multiplication modulo x^8 + x^4 + x^3 + x + 1 (0x11B)."""
    p = 0
    for _ in range(8):
        if b & 1:
            p ^= a
        hi_bit_set = a & 0x80
        a = (a << 1) & 0xFF
        if hi_bit_set:
            a ^= 0x1B  # Irreducible polynomial x^8 + x^4 + x^3 + x + 1
        b >>= 1
    return p

def gf_inverse(byte_val):
    """Finds the multiplicative inverse in GF(2^8) using Fermat's Little Theorem (a^(254))."""
    if byte_val == 0:
        return 0
    
    # Calculate byte_val^(254) using repeated squaring and multiplication
    # 254 in binary = 11111110
    result = 1
    base = byte_val
    exp = 254
    while exp > 0:
        if exp & 1:
            result = gf_multiply(result, base)
        base = gf_multiply(base, base)
        exp >>= 1
    return result

def circular_left_shift(val, n):
    """Performs an 8-bit circular left shift."""
    return ((val << n) | (val >> (8 - n))) & 0xFF

def calculate_sbox(byte_in):
    """Calculates the single-byte AES S-Box output using Affine Transformation."""
    inv = gf_inverse(byte_in)
    
    # Affine Transformation: 4 circular shifts + XOR with 0x63
    s1 = circular_left_shift(inv, 1)
    s2 = circular_left_shift(inv, 2)
    s3 = circular_left_shift(inv, 3)
    s4 = circular_left_shift(inv, 4)
    
    return inv ^ s1 ^ s2 ^ s3 ^ s4 ^ 0x63

def generate_verilog_sbox(output_filename="sbox.v"):
    """Generates the synthesizable Verilog module for the AES S-Box."""
    with open(output_filename, "w") as f:
        # Module Header
        f.write("module sbox (\n")
        f.write("    input  wire [7:0] in,\n")
        f.write("    output reg  [7:0] out\n")
        f.write(");\n\n")
        f.write("    always @(*) begin\n")
        f.write("        case (in)\n")
        
        # 256 Look-Up Table Entries
        for i in range(256):
            sbox_val = calculate_sbox(i)
            f.write(f"            8'h{i:02x}: out = 8'h{sbox_val:02x};\n")
            
        # Module Footer
        f.write("            default: out = 8'h63;\n")
        f.write("        endcase\n")
        f.write("    end\n\n")
        f.write("endmodule\n")

if __name__ == "__main__":
    generate_verilog_sbox("sbox.v")
    print("Successfully generated 'sbox.v' with complete 256 case mappings!")