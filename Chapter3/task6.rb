basket = {}

loop do
  print 'Введите название товара или стоп: '
  product = gets.chomp.downcase
  break if product == 'стоп'

  print 'Введите цену за еденицу товара: '
  price = gets.chomp.to_f

  print 'Введите количество купленного товара: '
  count = gets.chomp.to_f

  basket[product] = {
    price: price,
    count: count,
    total: price * count
  }
end

total_basket_sum = basket.sum { |k, v| v[:total] }

puts "\nВаш список покупок:"
basket.each { |title, product| puts "#{title} за #{product[:price]} руб. в количестве #{product[:count]} шт. В сумме на #{product[:total]} руб." }
puts "Итого вы потратили #{total_basket_sum} руб."
