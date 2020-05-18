print "Введите длину 1 стороны треугольника: "
a = gets.chomp.to_f

print "Введите длину 2 стороны треугольника: "
b = gets.chomp.to_f

print "Введите длину 3 стороны треугольника: "
c = gets.chomp.to_f

rectangular = false # Прямоугольный
equilateral = (a == b) && (a == c) # Равносторонный
isosceles = (a == b) || (a == c) || (b == c) # Равнобедренный

unless equilateral # Если треугольник не равносторонний, проверяем прямоугольный ли
  if (a > b) && (a > c)
    rectangular = a**2 == b**2 + c**2
  elsif (b > a) && (b > c)
    rectangular = b**2 == a**2 + c**2
  elsif (c > a) && (c > b)
    rectangular = c**2 == a**2 + b**2
  end
end


print "Треугольник "

if equilateral || isosceles || rectangular
  print "равносторонный " if equilateral
  print "равнобедренный " if isosceles
  print "прямоугольный " if rectangular
else
  print "обычный"
end

puts
