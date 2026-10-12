def gf_multiply(a, b):
    """Galois Field GF(2^8) multiplication with irreducible polynomial x^8 + x^4 + x^3 + x + 1 (0x11B)"""
    p = 0
    for _ in range(8):
        if b & 1:
            p ^= a
        hi_bit_set = a & 0x80
        a = (a << 1) & 0xFF
        if hi_bit_set:
            a ^= 0x1B
        b >>= 1
    return p

def gf_inverse(byte_val):
    """multiplicative inverse in GF(2^8) using brute-force search"""
    if byte_val == 0:
        return 0
    for candidate in range(1, 256):
        if gf_multiply(byte_val, candidate) == 1:
            return candidate
    return 0

def affine_transformation(inv_byte):
    """AES affine transformation to inverse byte"""
    x = inv_byte
    # Circular bit-shifts
    res = x ^ ((x << 1) | (x >> 7)) ^ ((x << 2) | (x >> 6)) ^ ((x << 3) | (x >> 5)) ^ ((x << 4) | (x >> 4))
    res = (res ^ 0x63) & 0xFF
    return res

def generate_sbox_mem(filename="sbox.mem"):
    """Generation and writing of 256 S-Box hex entries into a .mem file"""
    sbox = []
    for i in range(256):
        inv = gf_inverse(i)
        sbox_val = affine_transformation(inv)
        sbox.append(sbox_val)

    # Write formatted hex values into file (16 entries per row)
    with open(filename, "w") as f:
        for i in range(0, 256, 16):
            row_hex = " ".join(f"{val:02x}" for val in sbox[i:i+16])
            f.write(row_hex + "\n")

    print(f"File '{filename}' generated successfully with 256 S-Box values.")

if __name__ == "__main__":
    generate_sbox_mem("sbox.mem")