arr = [0, 1]

loop do
  new_number = arr[-1] + arr[-2]
  break if new_number > 100

  arr << new_number
end

print arr
