print 'Введите длину 1 стороны треугольника: '
a = gets.chomp.to_f

print 'Введите длину 2 стороны треугольника: '
b = gets.chomp.to_f

print 'Введите длину 3 стороны треугольника: '
c = gets.chomp.to_f

rectangular = false # Прямоугольный
equilateral = (a == b) && (a == c) # Равносторонный
isosceles = (a == b) || (a == c) || (b == c) # Равнобедренный

# Если треугольник не равносторонний, проверяем прямоугольный ли
unless equilateral
  abc_sorted = [a, b, c].sort
  rectangular = (abc_sorted[0]**2 + abc_sorted[1]**2).round(3) == (abc_sorted[2]**2).round(3)
end

print 'Треугольник '

if equilateral || isosceles || rectangular
  print 'равносторонный ' if equilateral
  print 'равнобедренный ' if isosceles
  print 'прямоугольный ' if rectangular
else
  print 'обычный'
end

puts
