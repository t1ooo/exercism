test: 1
expected="moves: 4, goalBucket: one, otherBucket: 5"
run bash two_bucket.sh 3 5 1 "one"
[#3, #5]
1: [0, 0]
2: [3, 0]
3: [1, 2]
4: [1, 5]

init()
fill(first)
transfuseFromTo(first, second)
fill(second)

if goalBucket == one && needleSize == oneBasketSize:
    return "moves: 1, goalBucket: $goalBucket, otherBucket: 0"

fill_1
pour_1
empty_1
fill_2
pour_2
empty_2


test: 2
[#3, #5]
1: [0, 0]
2: [0, 5]
3: [3, 2]
4: [3, 0]
5: [1, 2]
6: [1, 0]
7: [0, 1]
8: [3, 1]



