SUBLIST = "SUBLIST"
SUPERLIST = "SUPERLIST"
EQUAL = "EQUAL"
UNEQUAL = "UNEQUAL"


def is_sublist(lst, sublst):
    l = 0
    l_start = 0
    s = 0
    while l < len(lst) and s < len(sublst):
        if lst[l] == sublst[s]:
            l += 1
            s += 1
        else:
            l_start += 1
            l = l_start
            s = 0

    return s == len(sublst)


def sublist(a, b):
    if len(a) == len(b) and is_sublist(a, b):
        return EQUAL

    if len(a) > len(b) and is_sublist(a, b):
        return SUPERLIST

    if len(a) < len(b) and is_sublist(b, a):
        return SUBLIST

    return UNEQUAL
