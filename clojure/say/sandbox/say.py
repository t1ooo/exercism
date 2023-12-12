data = list(reversed([
    # (0, "zero"),
    (1, "one"),
    (2, "two"),
    (3, "three"),
    (4, "four"),
    (5, "five"),
    (6, "six"),
    (7, "seven"),
    (8, "eight"),
    (9, "nine"),

    (10, "ten"),
    (11, "eleven"),
    (12, "twelve"),
    (13, "thirteen"),
    (14, "fourteen"),
    (15, "fifteen"),
    (16, "sixteen"),
    (17, "seventeen"),
    (18, "eighteen"),
    (19, "nineteen"),

    (20, "twenty"),
    (30, "thirty"),
    (40, "forty"),
    (50, "fifty"),
    (60, "sixty"),
    (70, "seventy"),
    (80, "eighty"),
    (90, "ninety"),

    (100, "hundred"),

    (1000, "thousand"),

    (1000000, "million"),
    (1000000000, "billion"),
]))

data_with_zero = data + [(0, "zero")]


def sayV1(num):
    if num == 0:
        return "zero"

    res = []
    for n, text in data:
        if n > num:
            continue

        div = num//n
        # if div == 1 and n < 100:
        #     res.append(text)
        # else:
        #     res.append(sayV1(div))
        #     res.append(text)

        if div > 1 or n > 99:
            res.append(sayV1(div))

        res.append(text)

        num = num % n
        if num == 0:
            break

    return " ".join(res).replace("ty ", "ty-")


def sayV1_recV1(num):
    def f(num, d, res):
        if num == 0:
            res.append("zero")
            return

        if len(d) == 0:
            return

        n, text = d[0]
        d = d[1:]

        if n > num:
            f(num, d, res)
            return

        div = num//n
        # if div == 1 and n < 100:
        #     res.append(text)
        # else:
        #     f(div, data, res)
        #     res.append(text)

        if div > 1 or n > 99:
            # f(div, data, res)
            f(div, d, res)

        res.append(text)

        num = num % n
        if num == 0:
            return

        f(num, d, res)

    res = []
    f(num, data, res)
    return " ".join(res).replace("ty ", "ty-")


def sayV2(num):
    res = []
    for n, text in data_with_zero:
        if n > num:
            continue

        if n == num and n < 100:
            res.append(text)
            break

        div = num//n
        if n > 99:
            res.append(sayV1(div))

        res.append(text)

        num = num % n
        if num == 0:
            break

    return " ".join(res).replace("ty ", "ty-")


def sayV2_recV1(num):
    def f(num, d, res):
        if len(d) == 0:
            return

        n, text = d[0]
        d = d[1:]
        if n > num:
            f(num, d, res)
            return

        if n == num and n < 100:
            res.append(text)
            return

        div = num//n
        if n > 99:
            # f(div, data_with_zero, res)
            f(div, d, res)

        res.append(text)

        num = num % n
        if num == 0:
            return

        f(num, d, res)

    res = []
    f(num, data_with_zero, res)
    return " ".join(res).replace("ty ", "ty-")


def sayV2_recV2(num):
    def f(num, d):
        if len(d) == 0:
            return []

        n, text = d[0]
        d = d[1:]
        if n > num:
            return f(num, d)

        if n == num and n < 100:
            return [text]

        res = []
        div = num//n
        if n > 99:
            # res += f(div, data_with_zero)
            res += f(div, d)

        res.append(text)

        num = num % n
        if num == 0:
            return res

        return res + f(num, d)

    res = f(num, data_with_zero)
    return " ".join(res).replace("ty ", "ty-")


def sayV3(num):
    if num == 0:
        return "zero"

    res = []
    for n, text in data:
        if n > num:
            continue

        div = num//n
        # if div == 1 and n < 100:
        #     res.append(text)
        #     # if 19 < n and n < 100:
        #     if 19 < n:
        #         res.append("-")
        #     else:
        #         res.append(" ")
        # else:
        #     res.append(sayV2(div))
        #     res.append(" ")
        #     res.append(text)
        #     res.append(" ")

        if div > 1 or n > 99:
            res.append(sayV1(div))
            res.append(" ")

        res.append(text)
        if 19 < n and n < 100:
            print(num, div, n)
            res.append("-")
        else:
            res.append(" ")

        num = num % n
        if num == 0:
            break

    # print(res)
    return "".join(res).strip(" -")


def sayV4(num):
    def f(num, d):
        if num == 0:
            return ["zero"]

        if len(d) == 0:
            return []

        n, text = d[0]
        d = d[1:]

        if n > num:
            return f(num, d)

        dv = num // n
        rm = num % n
        next = f(rm, d) if rm > 0 else []
        delim = "-" if 19 < n else " "

        if n == num and n < 100:
            return [text, " "]
        elif dv == 1 and n < 100:
            return [text, delim] + next
        else:
            return f(dv, d) + [text, " "] + next

    res = f(num, data)
    # res = f(num, data_with_zero)
    return "".join(res).strip(" -")


def sayV5(num):
    def f(num, d, res):
        if len(d) == 0:
            return res

        if num == 0:
            # res += ["zero"]
            # return res
            return res + ["zero"]

        n, text = d[0]
        d = d[1:]

        if n > num:
            return f(num, d, res)

        dv = num // n
        rm = num % n
        # next =  f(rm, d) if rm > 0 else []
        delim = "-" if 19 < n else " "

        if n == num and n < 100:
            res += [text, " "]
            return res
        elif dv == 1 and n < 100:
            res += [text, delim]
            return f(rm, d, res)
            # return f(rm, d, res+[text, delim])
        else:
            f(dv, d, res)
            res += [text, " "]
            if rm > 0:
                res = f(rm, d, res)
            return res

    # res = []
    # f(num, data, res)
    res = f(num, data, [])
    # f(num, data_with_zero, res)
    return "".join(res).strip(" -")


def sayV6(num):
    def f(acc, d):
        num, res = acc
        if num == 0:
            return [num, res]

        n, text = d
        if n > num:
            return [num, res]

        dv = num // n
        rm = num % n
        delim = "-" if 19 < n else " "

        if n == num and n < 100:
            return [rm, res + [text, " "]]
        elif dv == 1 and n < 100:
            return [rm, res + [text, delim]]
        else:
            _, r = functools.reduce(f, data, [dv, []])
            return [rm, res + r + [text, " "]]

    if num == 0:
        return "zero"

    import functools
    _, res = functools.reduce(f, data, [num, []])
    return "".join(res).strip(" -")


dataSimple = list(reversed([
    # (0, "zero"),
    (1, "one"),
    (2, "two"),
    (3, "three"),
    (4, "four"),
    (5, "five"),
    (6, "six"),
    (7, "seven"),
    (8, "eight"),
    (9, "nine"),

    (10, "ten"),
    (11, "eleven"),
    (12, "twelve"),
    (13, "thirteen"),
    (14, "fourteen"),
    (15, "fifteen"),
    (16, "sixteen"),
    (17, "seventeen"),
    (18, "eighteen"),
    (19, "nineteen"),

    (20, "twenty"),
    (30, "thirty"),
    (40, "forty"),
    (50, "fifty"),
    (60, "sixty"),
    (70, "seventy"),
    (80, "eighty"),
    (90, "ninety"),
]))

dataComplex = [
    "",
    "thousand",
    "million",
    "billion",
]


def sayV7(num):
    def convert(num):
        res = []
        for n, text in dataSimple:
            if n > num:
                continue

            if n == num:
                res.append(text)
                break

            res.append(text)          
            res.append("-")

            num = num % n
            if num == 0:
                break

        return res

    def saySimple(num):
        res = []
        
        dv = num//100
        rm = num%100
        
        if dv > 0:
            res += convert(dv)
            res += ["hundred"]
        
        if rm > 0:
            res += convert(rm)
                
        return res

    def sayComplex(num, i):
        if num == 0:
            return []
        return [dataComplex[i]]


    if num == 0:
        return "zero"

    thousands = []
    i = 0
    while num > 0:
        thousands.append(saySimple(num%1000) + sayComplex(num%1000, i))
        num //= 1000
        i += 1

    return " ".join([" ".join(v) for v in reversed(thousands)]).replace(" - ", "-").strip(" ")


def test(fn):
    data = {
        14: "fourteen",
        987654321123: "nine hundred eighty-seven billion six hundred fifty-four million three hundred twenty-one thousand one hundred twenty-three",
        1000000000: "one billion",
        123: "one hundred twenty-three",
        100: "one hundred",
        1002345: "one million two thousand three hundred forty-five",
        1000000: "one million",
        1234: "one thousand two hundred thirty-four",
        1000: "one thousand",
        1: "one",
        20: "twenty",
        22: "twenty-two",
        0: "zero",
        120000: "one hundred twenty thousand",
    }
    for _in, out in data.items():
        assert fn(_in) == out, f"\n{out}\n{fn(_in)}"


# test(sayV1)
# test(sayV1_recV1)
# test(sayV2)
# test(sayV2_recV1)
# test(sayV2_recV2)
# test(sayV3)
# test(sayV4)
# test(sayV5)
# test(sayV6)
test(sayV7)


# print(sayV7(987654321123))
# print(sayV7(1000000000))
# print(sayV7(20))
# print(sayV7(0))
# print(sayV7(120000))
# sayV7(120001)
