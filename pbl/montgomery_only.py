def binary(n):
    return bin(n)[2:]

def pow_by_montgomery_ladder(a, x, n): # a^x mod n
    x = [int(b) for b in binary(x)[::-1]] #全体から要素を逆順に1個ずつ取り出す　整数にする
    k = len(x)
    for i in range(k - 1, -1, -1):  #kは2進数にしたxの桁数 [8,7,6,5,4,3,2,1,0]
        if x[i] == 0:
            a = (a**2) % n
        else:
            a = a  % n
    return a


def montgomery_divide(c1,c2,N): #(c*c)modN  divide alghorithm
    n = 8  # blocksize
    Nprime_under32 = int('0b11010111100101000011010111100101',0)
    c2_bin = bin(c2)
    b_array =[]
    b_array_int=[]
# add 0 in front of c_bin to adjust c_bin length
    if (len(c2_bin)<258):
        PlusBit = 258-len(c2_bin)
        c2_bin_front = c2_bin[0:2]
        c2_bin_end = c2_bin[2:]
        for i in range(PlusBit):
            c2_bin_front = c2_bin_front+'0'
        c2_bin = c2_bin_front + c2_bin_end
# divide c_bin each 32bits
# b_arrayにはc_binの下位ビットから入っている
    for i in range(8):
        b_array.append(c2_bin[(32*(7-i)+2):(32*(8-i)+2)])
    S = 0
    bitmask = 2**32-1
    for i in range(len(b_array)):
        b_array[i] = '0b' + b_array[i]
        b_array_int.append(int(b_array[i],0))

    # calculate montgomery_divide alghorithm
    for i in range(n):
        q_part = int(bin((S + b_array_int[i]*c1) & bitmask),0)
        q = int(bin((q_part * Nprime_under32) & bitmask),0)
        S = int(bin((S + q*N + b_array_int[i]*c1)>>32),0)
    return S

Nprime = int('0xb65373ccba60808c92022379c45b843c6e371ba81104f6c808435e50d79435e5',0)
u = -(2**62+2**55+1)
N = 36 * u ** 4 + 36 * u ** 3 + 24 * u ** 2 + 6 * u + 1
print("N")
print(N)
#confirm a*a mod N
a = 2
c = (pow_by_montgomery_ladder(2,256,N) * a) % N

print("a*a mod N")
sum = montgomery_divide(c,c,N) #(sum*sum) mod N
print(sum)
print(bin(sum))
print(hex(sum))

print("montgomery形式のmultiplicand")
print(bin(c))
print(c)

print("montgomery reduction")
#ビットマスク
bitmask = 2**256-1
sumNprime_modR = int(bin(sum*Nprime & bitmask),0)
#ビットシフト
int_sum = int(bin((sum + sumNprime_modR * N)>>256),0)
print(int_sum)
print(bin((sum + sumNprime_modR * N)>>256))

