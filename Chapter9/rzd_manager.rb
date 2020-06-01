# frozen_string_literal: true

require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'validate'

# RzdManager class
class RzdManager
  include Validate

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run
    loop do
      menu
      choice = gets.chomp

      case choice
      when '1' then create_station
      when '2' then create_train
      when '3' then manage_route
      when '4' then route_to_train
      when '5' then manage_wagon
      when '6' then manage_move
      when '7' then display_stations
      when '8' then seed
      when '0'
        puts message_regular('Пока!')
        break
      else
        puts message_alert('Неверный ввод. Повторите')
      end
    end
  end

  def seed
    @stations = []
    @trains = []
    @routes = []

    @stations.push(Station.new('Тюмень'))
    @stations.push(Station.new('Москва'))
    @stations.push(Station.new('Омск'))
    @stations.push(Station.new('Сургут'))
    @stations.push(Station.new('Владивосток'))
    @stations.push(Station.new('Хабаровск'))
    @stations.push(Station.new('Ишим'))

    train1 = PassengerTrain.new('пас-01')
    @trains.push(train1)
    @trains.push(PassengerTrain.new('пас-02'))
    @trains.push(PassengerTrain.new('пас-03'))
    @trains.push(PassengerTrain.new('пас-04'))

    train2 = CargoTrain.new('грз-01')
    @trains.push(train2)
    @trains.push(CargoTrain.new('грз-02'))
    @trains.push(CargoTrain.new('грз-03'))
    @trains.push(CargoTrain.new('грз-04'))

    wagon1 = PassengerWagon.new(10)
    wagon1.take_seat
    wagon1.take_seat
    wagon1.take_seat

    train1.attach_wagon(wagon1)
    train1.attach_wagon(PassengerWagon.new(20))
    train1.attach_wagon(PassengerWagon.new(15))

    wagon2 = CargoWagon.new(100)
    wagon2.take_volume(70)

    train2.attach_wagon(wagon2)
    train2.attach_wagon(CargoWagon.new(150))
    train2.attach_wagon(CargoWagon.new(200))

    route1 = Route.new(@stations[0], @stations[5])
    route1.add_station(@stations[1], -2)
    route1.add_station(@stations[3], -2)
    route1.add_station(@stations[4], -2)

    route2 = Route.new(@stations[1], @stations[2])

    @routes.push(route1)
    @routes.push(route2)
    @routes.push(Route.new(@stations[3], @stations[4]))

    train1.route = route1
    train2.route = route2

    puts message_success('Данные успешно очищены и созданы')
  rescue StandardError => e
    puts message_alert(e.message)
  end

  private

  RED = "\033[0;31m"
  GREEN = "\033[0;32m"
  NC = "\033[0m" # No Color

  def menu
    puts "\nМеню управления РЖД"
    puts "1 - Создать станцию (станций #{@stations.size})"
    puts "2 - Создать поезд (поездов #{@trains.size})"
    puts "3 - Создать маршрут и управлять станциями в нем (маршрутов #{@routes.size})"
    puts '4 - Назначить маршрут поезду'
    puts '5 - Управление вагонами'
    puts '6 - Переместить поезд по маршруту вперед или назад'
    puts '7 - Посмотреть список станций и список поездов на станции'
    puts '8 - Очистить и заполнить базу тестовыми данными'
    puts '0 - Покинуть пост управляющего'
    print 'Выберите действие: '
  end

  def manage_move
    loop do
      puts 'Что вы хотите сделать?'
      puts '1 - Переместить поезд на следующую станцию'
      puts '2 - Переместить поезд на предыдущую станцию'
      puts '0 - Назад'
      choice = gets.chomp

      case choice
      when '1'
        goto_train_next_station
      when '2'
        goto_train_prev_station
      when '0'
        return
      else
        puts message_alert('Неверный выбор. Повторите ввод')
        next
      end

      break
    end
  end

  def goto_train_next_station
    train = interactive_select_train
    current_station = train.goto_next_station

    puts message_success("Поезд перемещен. Текущая станция #{current_station.name}")

  rescue StandardError => e
    puts message_alert(e.message)
  end

  def goto_train_prev_station
    train = interactive_select_train
    current_station = train.goto_prev_station

    puts message_success("Поезд перемещен. Текущая станция #{current_station.name}")

  rescue StandardError => e
    puts message_alert(e.message)
  end

  def manage_wagon
    loop do
      puts 'Что вы хотите сделать?'
      puts '1 - Прицепить вагон к поезду'
      puts '2 - Отцепить вагон от поезда'
      puts '3 - Заполнить вагон'
      puts '0 - Назад'
      choice = gets.chomp

      case choice
      when '1'
        attach_wagon_to_train
      when '2'
        detach_wagon_from_train
      when '3'
        fill_wagon
      when '0'
        return
      else
        puts message_alert('Неверный выбор. Повторите ввод')
        next
      end

      break
    end
  end

  def attach_wagon_to_train
    train = interactive_select_train
    wagon = nil

    case train.type
    when :passenger
      print 'Введите количество свободных мест в вагоне: '
      seats = gets.chomp.to_i
      wagon = PassengerWagon.new(seats)
    when :cargo
      print 'Введите объем свободого места в вагоне: '
      volume = gets.chomp.to_f
      wagon = CargoWagon.new(volume)
    end

    train.attach_wagon(wagon)
    puts message_success("Вагон №#{train.count_wagons} успешно прицеплен")

  rescue StandardError => e
    puts message_alert(e.message)
  end

  def detach_wagon_from_train
    train = interactive_select_train
    wagon = train.wagons.last

    train.detach_wagon(wagon)
    puts message_success("Вагон №#{train.count_wagons + 1} успешно отцеплен")

  rescue StandardError => e
    puts message_alert(e.message)
  end

  def fill_wagon
    train = interactive_select_train
    index_wagon = 0

    if train.wagons.empty?
      puts message_alert('У поезда нет вагонов')
      return
    end

    puts 'Выберите номер вагона: '
    train.wagons.each_with_index do |wagon, index|
      free = case wagon.type
             when :passenger
               wagon.free_seats
             when :cargo
               wagon.free_volume
             else
               'неизвестно'
             end
      puts "#{index + 1} - свободно: #{free}"
    end

    loop do
      print ': '
      index_wagon = gets.chomp.to_i
      break if (1..train.wagons.size).include?(index_wagon)

      puts message_alert('Неверный выбор. Повторите')
    end

    wagon = train.wagons[index_wagon - 1]

    case wagon.type
    when :passenger
      wagon.take_seat
      puts message_success('Вы заполнили одно место в вагоне')
    when :cargo
      print 'Введите, сколько вы хотите места заполнить: '
      volume = gets.chomp.to_f
      wagon.take_volume(volume)
      puts message_success("Вы заполнили #{volume} место в вагоне")
    end
  rescue StandardError => e
    puts message_alert(e.message)
    retry
  end

  def route_to_train
    route = interactive_select_route
    train = interactive_select_train

    unless train.route.nil?
      puts 'У поезда уже установлен маршрут'
      train.route.display_stations
      choice = nil

      loop do
        print 'Заменить? 0 - НЕТ, 1 - ДА: '
        choice = gets.chomp

        break if ('0'..'1').include?(choice)

        puts message_alert('Неверный ввод')
      end

      return if choice == '0'
    end

    train.route = route

    puts message_success('Маршрут успешно установлен')
  rescue StandardError => e
    puts message_alert(e.message)
  end

  def display_stations
    puts 'Список станций и поездов на них'
    Station.each do |station|
      puts "Станция #{station.name}"
      station.each_trains do |train|
        puts "\t#{train.number}, #{Train::VALID_TRAIN_TYPES[train.type]}, #{train.count_wagons} вагонов"
        train.each_with_index_wagons do |wagon, index|

          free = case wagon.type
                 when :passenger
                   wagon.free_seats
                 when :cargo
                   wagon.free_volume
                 else
                   'неизвестно'
                 end

          busy = case wagon.type
                 when :passenger
                   wagon.busy_seats
                 when :cargo
                   wagon.busy_volume
                 else
                   'неизвестно'
                 end

          puts "\t\t#{index + 1}, #{Wagon::VALID_WAGON_TYPES[wagon.type]}, свободно #{free}, занято #{busy}"
        end
      end
    end
  rescue StandardError => e
    puts message_alert(e.message)
  end

  def create_station
    print 'Введите название станции: '
    name = gets.chomp

    station = Station.new(name)
    @stations.push(station)

    puts message_success('Станция успешно создана')

    station
  rescue StandardError => e
    puts message_alert(e.message)
    retry
  end

  def create_train
    print 'Введите номер поезда: '
    number = gets.chomp
    train = nil

    loop do
      puts 'Выберите тип поезда: '
      puts '1 - Пассажирский'
      puts '2 - Грузовой'
      print ': '
      type_choice = gets.chomp

      case type_choice
      when '1'
        train = PassengerTrain.new(number)
      when '2'
        train = CargoTrain.new(number)
      else
        puts message_alert('Неверный выбор. Повторите')
        next
      end

      break
    end

    @trains.push(train)

    puts message_success('Поезд успешно создан')

    train

  rescue StandardError => e
    puts message_alert(e.message)
    retry
  end

  def manage_route
    loop do
      puts 'Что вы хотите сделать?'
      puts '1 - Создать новый маршрут'
      puts '2 - Добавить станцию в существующий маршрут'
      puts '3 - Удалить станцию из существующего маршрута'
      puts '0 - Назад'
      choice = gets.chomp

      case choice
      when '1'
        create_route
      when '2'
        add_station_to_route
      when '3'
        delete_station_from_route
      when '0'
        return
      else
        puts message_alert('Неверный выбор. Повторите ввод')
        next
      end

      break
    end
  end

  def delete_station_from_route
    station = nil
    station_index = nil
    route = interactive_select_route

    if route.stations.size == 2
      puts message_alert('В маршруте только 2 станции. Удалить начальную или конечную станцию нельзя')
      return
    end

    loop do
      print "Выберите номер станции для удаления из маршрута (2..#{route.stations.size - 1}): "
      station_index = gets.chomp.to_i - 1

      break if station_index.positive? && station_index < route.stations.size - 1

      puts message_alert('Неверный выбор. Повторите ввод')
    end

    route.delete_station(route.stations[station_index])

    puts message_success('Станция успешно удалена из маршрута')
  rescue StandardError => e
    puts message_alert(e.message)
  end

  def add_station_to_route
    station = nil
    insert_index = nil
    route = interactive_select_route

    available_station = @stations.reject { |station| route.stations.include?(station) }

    if available_station.empty?
      puts message_alert('Нет свободных станций для данного маршрута')
      return
    end

    loop do
      puts 'Выберите станцию:'
      available_station.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }

      print ': '
      available_station_index = gets.chomp.to_i

      if available_station_index.positive? && available_station_index <= available_station.size
        station = available_station[available_station_index - 1]
        break
      end

      puts message_alert('Неверный выбор. Повторите ввод')
    end

    loop do
      print "Введите порядковый номер стрелочки (->), за место которой вставить станцию (1..#{route.stations.size - 1}): "
      insert_index = gets.chomp.to_i

      break unless insert_index < 1 || insert_index >= route.stations.size

      puts message_alert('Неверный выбор. Повторите ввод')
    end

    route.add_station(station, insert_index)
  rescue StandardError => e
    puts message_alert(e.message)
  end

  def create_route
    if @stations.size < 2
      puts message_alert('Должно быть создано минимум 2 станции')
      return
    end

    from_station = nil
    to_station = nil

    loop do
      puts 'Список существующий станций:'
      @stations.each_with_index { |station, index| puts "#{index + 1} - #{station.name}" }
      puts 'Введите номер начальной станции маршрута'
      from = gets.chomp.to_i

      if from < 1 || from > @stations.size
        puts message_alert('Неверный выбор начальной станции')
        next
      end

      puts 'Введите номер конечной станции маршрута'
      to = gets.chomp.to_i

      if to < 1 || to > @stations.size
        puts message_alert('Неверный выбор конечной станции')
        next
      end

      if from == to
        puts message_alert('Одна и так же станция не может быть и начальной и конечной')
        next
      end

      from_station = @stations[from - 1]
      to_station = @stations[to - 1]

      break

    end

    route = Route.new(from_station, to_station)

    @routes.push(route)

    puts message_success('Маршрут успешно создан')

    route
  rescue StandardError => e
    puts message_alert(e.message)
  end

  def interactive_select_train
    train = nil

    loop do
      puts 'Выберите поезд:'
      @trains.each_with_index { |train, index| puts "#{index + 1} - #{train.number} (вагонов #{train.count_wagons})" }

      print ': '
      train_index = gets.chomp.to_i

      if train_index.positive? && train_index <= @trains.size
        train = @trains[train_index - 1]
        break
      end

      puts message_alert('Неверный выбор. Повторите ввод')
    end

    train
  end

  def interactive_select_route
    route = nil

    loop do
      puts 'Выберите маршрут:'
      @routes.each_with_index do |route, index|
        print "#{index + 1} - "
        route.display_stations
      end

      print ': '
      route_index = gets.chomp.to_i

      if route_index.positive? && route_index <= @routes.size
        route = @routes[route_index - 1]
        break
      end

      puts message_alert('Неверный выбор. Повторите ввод')
    end

    route
  end

  def message_alert(msg)
    "#{RED}-----\n#{msg}\n-----\n#{NC}"
  end

  def message_success(msg)
    "#{GREEN}-----\n#{msg}\n-----\n#{NC}"
  end

  def message_regular(msg)
    "-----\n#{msg}\n-----\n"
  end
end
