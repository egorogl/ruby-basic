print 'Введите ваше имя: '
name = gets.chomp

print 'Введите ваш рост в сантиметрах: '
height = gets.chomp.to_i

ideal_weight = ((height - 110) * 1.15).round(2)

if ideal_weight < 0
  puts 'Ваш вес уже оптимальный'
else
  puts "#{name}, ваш идеальный вес #{ideal_weight} кг."
end
