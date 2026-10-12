from Crypto.Cipher import AES

def aes_128_encryptor(plaintext_hex, key_hex):
    """
    Encrypts a 128-bit plaintext using a 128-bit key using standard AES.
    Returns the ciphertext in hexadecimal format.
    """
    # hexadecimal strings into raw bytes
    # Hardware takes hex values, but Python's AES library requires raw byte arrays
    plaintext_bytes = bytes.fromhex(plaintext_hex)
    key_bytes = bytes.fromhex(key_hex)
    
    # new AES cipher object
    # AES.MODE_ECB (Electronic Codebook) is used here because it encrypts exactly 
    # one single 128-bit block independently, which is exactly what hardware core does.
    cipher = AES.new(key_bytes, AES.MODE_ECB)
    
    # Encryption
    ciphertext_bytes = cipher.encrypt(plaintext_bytes)
    
    # Convert result ciphertext bytes back to a readable hex string
    ciphertext_hex = ciphertext_bytes.hex()
    
    return ciphertext_hex

def hardware_verifier(plaintext_hex, key_hex, verilog_ciphertext_hex):

    print("_____________________________________")
    print("        AES-128 HARDWARE VERIFICATION")
    print("*************************************")
    
    # Display the inputs
    print(f"Plaintext In  : {plaintext_hex}")
    print(f"Key In        : {key_hex}")
    print("_____________________________________")
    
    # expected ciphertext using Python Encryptor
    python_expected_out = aes_128_encryptor(plaintext_hex, key_hex)
    
    print(f"Python Output : {python_expected_out}")
    print(f"Verilog Output: {verilog_ciphertext_hex}")
    print("--------------------------------------------------")
    
    # actual Verification Logic (Comparator)
    if python_expected_out == verilog_ciphertext_hex:
        print("[Result] -> PASS! Hardware matches Software perfectly.")
    else:
        print("[Result] -> FAIL! Outputs do not match. Check RTL logic.")
    print("__________________________________________________")


if __name__ == "__main__":
    # ______________________________________________________________
    # Test 1: NIST Standard Vector (The one we simulated in Verilog)
    # inputs used in tb_main_aes.v
    test_plaintext = "3243f6a3339a308d313198a2e0370734"
    test_key       = "2b7e151628aeda45abf7331209cf4f3c"
    
    # final ciphertext
    verilog_result = "4f640b1a85bdf0fb515c807aab3b9d5b"
    
    # Run the verifier
    hardware_verifier(test_plaintext, test_key, verilog_result)