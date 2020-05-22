# frozen_string_literal: true

# RzdManager class
class RzdManager
  RED = "\033[0;31m"
  GREEN = "\033[0;32m"
  NC = "\033[0m" # No Color

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    loop do
      menu
      choice = gets.chomp
      puts

      case choice
      when '1'
        create_station
      when '0'
        puts 'Пока!'
        break
      else
        puts "#{RED}Неверный ввод#{NC}\n"
      end
    end

  end

  def menu
    puts "\nМеню управления РЖД"
    puts '1 - Создать станцию'
    puts '2 - Создать поезд'
    puts '3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)'
    puts '4 - Назначить маршрут поезду'
    puts '5 - Добавить вагон к поезду'
    puts '6 - Отцепить вагон от поезда'
    puts '7 - Переместить поезд по маршруту вперед или назад'
    puts '8 - Посмотреть список станций и список поездов на станции'
    puts '0 - Покинуть пост управляющего'
    print 'Выберите действие: '
  end

  def create_station
    print 'Введите название станции: '
    name = gets.chomp

    station = Station.new(name)
    @stations.push(station)

    puts "\n#{GREEN}Станция успешно создана#{NC}\n"
  end
end