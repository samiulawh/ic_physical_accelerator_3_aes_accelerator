# function converting decimal to binary
def dec_to_bin(num):
    arr = []

    while num > 0:
        temp = num % 2

        if temp == 1:
            arr.append(1)
        else:
            arr.append(0)

        num = num // 2

    arr.reverse()
    arr = ''.join(map(str, arr))

    return arr

decimal = 143
binary = dec_to_bin(decimal)
print("")
print(f"decimal = {decimal} | binary = >>>{binary}<<<")
