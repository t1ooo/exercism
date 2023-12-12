    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1

1  1 1  1 2 1  1 3 3 1  1 4 6 4 1
0  1 2  3 4 5  6 7 8 9



        1
       1 1
      1 2 1
     1 3 3 1
    1 4 6 4 1
  1 5 10 10 5 1
1 6 15 20 15 6 1


1
1 1
1 2 1
1 3 3 1
1 4 6 4 1


0 1
0 1 1
0 1 2 1
0 1 3 3 1
1 4 6 4 1


0 1 3 3 1
1 3 3 1 0


rows[current-1][i] + rows[current-1][i-1]

prev_row = rows[current-1]

prev_row[i] ?? 0  + prev_row[i-1] ?? 0

def gen_row(limit prev_row):
    row = []
    for i in range(limit):
        row[] = prev_row[i] ?? 0  + prev_row[i-1] ?? 0
    return row

def gen(n):
    rows = [[1]]
    for i in range(n):
        row[i+1][gen_row(limit prev_row)




def gen_row(limit prev_row):
    if not prev_row:
        return [1]
    row = []
    for i in range(limit):
        row.append(prev_row[i] ?? 0  + prev_row[i-1] ?? 0)
    return row

def gen(n):
    rows = []
    for i in range(n):
        prev_row = rows[i-1] ?? None
        row.append([gen_row(limit, prev_row))