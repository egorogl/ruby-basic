print 'Введите коэффициент a: '
a = gets.chomp.to_f

print 'Введите коэффициент b: '
b = gets.chomp.to_f

print 'Введите коэффициент c: '
c = gets.chomp.to_f

d = (b**2) - (4 * a * c)

print "Дискриминант = #{d}, "

if d.negative?
  puts 'Корней нет'
elsif d.zero?
  x = -b / (2 * a)
  puts "Корень = #{x}"
else
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  puts "Корни = #{x1}, #{x2}"
end
