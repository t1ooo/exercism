1 2 3
8 9 4
7 6 5


1 2 3
4 5 6
7 8 9

11 21 31    
32 33         
23 13       
12    

3(x+1 y)
2(x y+1)  
2(x-1 y) 
1(x y-1)

2(x+1 y)
2(x y+1)
2(x-1 y)
2(x y-1)

// code 5
class LoopEnd(Exception): pass

def fill_matrix(size):
    max = size * size
    m = [ [0]*size for i in range(size) ]
    i=1
    x_begin = 0
    y_begin = 0
    next = [
        {'x': lambda x: x+1, 'y': lambda y: y},
        {'x': lambda x: x  , 'y': lambda y: y+1},
        {'x': lambda x: x-1, 'y': lambda y: y},
        {'x': lambda x: x  , 'y': lambda y: y-1},
    ]
    try:
        while True:
            x=x_begin
            y=y_begin
            if (size <= 1):
                m[y][x] = i
                raise LoopEnd          
            for _, n in enumerate(next):
                for _ in range(0,size-1):
                    m[y][x] = i
                    i+=1
                    x=n['x'](x)
                    y=n['y'](y)
                    if i > max: 
                        raise LoopEnd         
            size-=2
            x_begin+=1
            y_begin+=1
    except LoopEnd:
        pass
    return m

fill_matrix(3)

size = 3
max = size * size
m = [ [0]*size for i in range(size) ]
i=1
x=0
y=0
fill_matrix(m, size, i, x, y)
// code 5 end


// code 4
size = 3
max = size * size
m = [ [0]*size for i in range(size) ]
# fill external square
i=1
x=0
y=0
next = [
    {'x': lambda x: x+1, 'y': lambda y: y},
    {'x': lambda x: x  , 'y': lambda y: y+1},
    {'x': lambda x: x-1, 'y': lambda y: y},
    {'x': lambda x: x  , 'y': lambda y: y-1},
]
for _, n in enumerate(next):
    for _ in range(0,size-1):
        m[y][x] = i
        i+=1
        x=n['x'](x)
        y=n['y'](y)

# fill internal square
size = size-2
x=1
y=1

if (size == 1):
    m[y][x] = i
else:
    for _, n in enumerate(next):
        for _ in range(0,size-1):
            m[y][x] = i
            i+=1
            x=n['x'](x)
            y=n['y'](y)
            if i > max: break
            #if x >= size or y >= size:
            #    break
        else:
            continue
        break

// code 4 end

// code 2
size = 3
m = [ [0]*3 for i in range(3) ]

i=1
x=0
y=0
for n in range(0,size-1):
    m[y][x] = i
    i+=1
    x+=1

for n in range(0,size-1):
    m[y][x] = i
    i+=1
    y+=1

for n in range(0,size-1):
    m[y][x] = i
    i+=1
    x-=1

for n in range(0,size-1):
    m[y][x] = i
    i+=1
    y-=1
// code 2 end

// code
size = 3
m = [ [0]*3 for i in range(3) ]

i=1
x=0
y=0
for n in range(0,size):
    m[y][x] = i
    i+=1
    x+=1

x=size-1
y=1
for n in range(0,size-1):
    m[y][x] = i
    i+=1
    y+=1

x=size-1-1
y=size-1
for n in range(0,size-1):
    m[y][x] = i
    i+=1
    x-=1
// code end



+0 +1 +2
+7 +8 +3
+6 +5 +4


0.0 0.1 0.2
1.0 1.1 1.2
2.0 2.1 2.2

1+size*0 2+size*0 3+size*0


1   2  3
+7 +7 +1
+6 +4 +2

16 17 12

6
21
18

r r d d l l u r

1 2 3
    4   89
    5 6 7

3 3 3 2 2 = s s s s-1 s-1

2r 2d 2l 1u 1r = s-1 s-1 s-1 s-2 s-2

-------------------------

 1  2  3 4
12 13 14 5
11 16 15 6
10  9  8 7

 1  2  3  4
 5  6  7  8
 9 10 11 12
13 14 15 16

r r r d d d l l l u u r r d l

1 2 3 4
      5     12 13 14
      6     11    15 16
      7 8 9 10

4 4 4 3 3 2 2 = s s s s-1 s-1 s-2 s-2

3r 3d 3l 2u 2r 1d 1l = s-1 s-1 s-1 s-2 s-2 s-3 s-3

-------------------------
1   2  3  4 5
16 17 18 19 6
15 24 25 20 7
14 23 22 21 8
13 12 11 10 9

r r r r d d d d l l l l u u u r r r d d l l u r


1   2  3  4 5
            6          16 17 18 19
            7          15       20    24 25
            8          14       21 22 23
            9 10 11 12 13

5 5 5 4 4 3 3 2 2 = s s s s-1 s-1 s-2 s-2 s-3 s-3
4r 4d 4l 3u 3r 2d 2l 1u 1r = s-1 s-1 s-1 s-2 s-2 s-3 s-3 s-4 s-4