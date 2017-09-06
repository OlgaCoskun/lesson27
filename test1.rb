arr = [5, 6, 8, 4]
arr << 3
arr.reverse!
res = arr[2...4]
puts res[1]