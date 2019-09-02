# --------------------------------------------------------------------------------

u = -(2 ** 62 + 2 ** 55 + 1)

N = 36 * u ** 4 + 36 * u ** 3 + 24 * u ** 2 + 6 * u + 1

exp = 256

R = 2 ** exp

R2 = (R ** 2) % N


# --------------------------------------------------------------------------------

def calcurate_N_prime():
    result = 0
    t = 0
    r = R
    i = 1

    while(r > 1):
        if(t & 1 == 0):
            t += N
            result += i
        t >>= 1
        r >>= 1
        i <<= 1

    return result


N_prime = calcurate_N_prime()


# --------------------------------------------------------------------------------

def MR(A, B):  # MontgomeryReduction
    return (A * B + (A * B * N_prime & (R - 1)) * N) >> exp


# --------------------------------------------------------------------------------

def split_MR(A, B):  # 分割モンゴメリ
    k = 32  # 分割サイズ
    n = exp // k  # ブロック数

    mask = 2 ** k - 1  # マスクする数

    N_prime_prime = N_prime & mask  # 補足参照

    sum = 0

    for i in range(n):
        b = (B >> (k * i)) & mask
        q = (((sum + b * A) & mask) * N_prime_prime) & mask
        sum = (sum + q * N + b * A) >> k

    return sum


# --------------------------------------------------------------------------------
# https://qiita.com/NaokiOsako/items/2404a7217347363c482d

def MMM(a, b):  # MontgomeryModularMultiplication
    A = split_MR(a, R2)
    B = split_MR(b, R2)
    return split_MR(split_MR(A, B), 1)


# --------------------------------------------------------------------------------

def binary_mod_N(base, exp):
    mask = 1 << exp.bit_length() - 1

    ans = 1

    while mask:
        ans = MMM(ans, ans)

        if exp & mask:
            ans = MMM(ans, base)

        mask >>= 1

    return ans


# --------------------------------------------------------------------------------

print(format(binary_mod_N(2, 40710), 'x'))
