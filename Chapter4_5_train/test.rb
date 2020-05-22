# frozen_string_literal: true

require_relative 'route'
require_relative 'station'
require_relative 'train'

train1 = Train.new('1', :passenger, 5)
train2 = Train.new('2', :passenger, 10)

station1 = Station.new('Станция1')
station2 = Station.new('Станция2')
station3 = Station.new('Станция3')
station4 = Station.new('Станция4')
station5 = Station.new('Станция5')
station6 = Station.new('Станция6')

route1 = Route.new(station1, station5)

route1.display_stations

puts 'Добавляем стацнии'

route1.add_station(station2, -2)
route1.add_station(station3, -2)
route1.add_station(station4, -2)
route1.add_station(station6, -2)

route1.display_stations

puts 'Удаляем стацнию'

route1.delete_station(station6)

route1.display_stations

puts "Кол-во вагонов у поезд № #{train1.number} = #{train1.count_wagons}"
puts "Кол-во вагонов у поезд № #{train2.number} = #{train2.count_wagons}"

puts "Добавили вагон к поезду № #{train1.number}"
train1.attach_wagon

puts "Убрали вагон у поезда № #{train2.number}"
train2.detach_wagon

puts "Кол-во вагонов у поезд № #{train1.number} = #{train1.count_wagons}"
puts "Кол-во вагонов у поезд № #{train2.number} = #{train2.count_wagons}"

puts 'Разгоним 2 поезда и на ходу отцепим вагоны у первого и прицепим ко второму!'
train1.speed = 100
train2.speed = 80

train1.detach_wagon
train2.attach_wagon

puts "Кол-во вагонов у поезд № #{train1.number} = #{train1.count_wagons}"
puts "Кол-во вагонов у поезд № #{train2.number} = #{train2.count_wagons}"

puts 'Установим маршрут для первого поезда'
train1.route = route1

puts "Текущая станция поезда № #{train1.number} = #{train1.current_station.name}"
puts 'Едем дальше...'

train1.goto_next_station

puts "Текущая станция поезда № #{train1.number} = #{train1.current_station.name}"

puts 'Едем дальше...'

train1.goto_next_station

puts 'Посмотрим предыдущую, текущую и следующую станцию'
train1.sibling_stations.each do |station|
  print "#{station.name} с пассажирскими поездами: "
  trains_in_station = station.get_trains_by_type(:passenger)

  if trains_in_station.empty?
    print 'пусто'
  else
    trains_in_station.each { |train| print "Поезд №#{train.number} " }
  end

  puts

end

puts 'Установим тот же маршрут для второго поезда'
train2.route = route1

puts "Текущая станция поезда № #{train2.number} = #{train2.current_station.name}"
puts 'Едем дальше...'

train2.goto_next_station

puts "Текущая станция поезда № #{train2.number} = #{train2.current_station.name}"

puts 'Едем дальше...'

train2.goto_next_station

puts 'Посмотрим предыдущую, текущую и следующую станцию'
train2.sibling_stations.each do |station|
  print "#{station.name} с пассажирскими поездами: "
  trains_in_station = station.get_trains_by_type(:passenger)

  if trains_in_station.empty?
    print 'пусто'
  else
    trains_in_station.each { |train| print "Поезд №#{train.number} " }
  end

  puts

end