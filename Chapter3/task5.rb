month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30]

print 'Введите дату в формате дд.мм.гггг: '
day, month, year = gets.chomp.split('.').map(&:to_i)

month_days[1] = 29 if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)

days_passed = month_days.take(month - 1).sum + day

puts "Прошло с начала #{year} года #{days_passed} дней"
