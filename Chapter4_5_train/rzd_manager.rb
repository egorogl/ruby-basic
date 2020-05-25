# frozen_string_literal: true

require_relative 'route'
require_relative 'station'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'

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

  def run
    loop do
      menu
      choice = gets.chomp

      case choice
      when '1'
        create_station
      when '2'
        create_train
      when '3'
        manage_route
      when '4'
        route_to_train
      when '5'
        attach_wagon_to_train
      when '6'
        detach_wagon_from_train
      when '7'
        manage_move
      when '8'
        display_stations
      when '9'
        seed
      when '0'
        puts message_regular('Пока!')
        break
      else
        puts message_alert('Неверный ввод')
      end
    end
  end

  def menu
    puts "\nМеню управления РЖД"
    puts "1 - Создать станцию (станций #{@stations.size})"
    puts "2 - Создать поезд (поездов #{@trains.size})"
    puts "3 - Создать маршрут и управлять станциями в нем (маршрутов #{@routes.size})"
    puts '4 - Назначить маршрут поезду'
    puts '5 - Добавить вагон к поезду'
    puts '6 - Отцепить вагон от поезда'
    puts '7 - Переместить поезд по маршруту вперед или назад'
    puts '8 - Посмотреть список станций и список поездов на станции'
    puts '9 - Очистить и заполнить базу тестовыми данными'
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

    if current_station.nil?
      puts message_alert('Поезд не переместился. У поезда нет маршрута или конечная станция')
    else
      puts message_success("Поезд перемещен. Текущая станция #{current_station.name}")
    end
  end

  def goto_train_prev_station
    train = interactive_select_train
    current_station = train.goto_prev_station

    if current_station.nil?
      puts message_alert('Поезд не переместился. У поезда нет маршрута или конечная станция')
    else
      puts message_success("Поезд перемещен. Текущая станция #{current_station.name}")
    end
  end

  def attach_wagon_to_train
    train = interactive_select_train
    wagon = nil

    case train.type
    when :passenger
      wagon = PassengerWagon.new
    when :cargo
      wagon = CargoWagon.new
    end

    if train.attach_wagon(wagon).nil?
      puts message_alert('Вагон не прицеплен')
    else
      puts message_success("Вагон №#{train.count_wagons} успешно прицеплен")
    end
  end

  def detach_wagon_from_train
    train = interactive_select_train
    wagon = train.wagons.last

    if wagon.nil?
      puts message_alert('У поезда нет вагонов')
      return
    end

    if train.detach_wagon(wagon).nil?
      puts message_alert('Вагон не отцеплен')
    else
      puts message_success("Вагон №#{train.count_wagons + 1} успешно отцеплен")
    end
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
  end

  def display_stations
    puts 'Список станций и поездов на них'
    @stations.each do |station|
      puts "Станция | #{station.name}"
      puts "\tПассажирские поезда:"
      station.get_trains_by_type(:passenger).each { |train| puts "\t\tПоезд | #{train.number}"  }
      puts "\tГрузовые поезда:"
      station.get_trains_by_type(:cargo).each { |train| puts "\t\tПоезд | #{train.number}"  }
    end
  end

  def create_station
    print 'Введите название станции: '
    name = gets.chomp

    station = Station.new(name)
    @stations.push(station)

    puts message_success('Станция успешно создана')

    station
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
        puts message_alert('Неверный выбор типа поезда. Повторите ввод')
        next
      end

      break

    end

    @trains.push(train)

    puts message_success('Поезд успешно создан')

    train
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

    train1 = PassengerTrain.new('Пассажирский1')
    @trains.push(train1)
    @trains.push(PassengerTrain.new('Пассажирский2'))
    @trains.push(PassengerTrain.new('Пассажирский3'))
    @trains.push(PassengerTrain.new('Пассажирский4'))

    @trains.push(CargoTrain.new('Грузовой1'))
    @trains.push(CargoTrain.new('Грузовой2'))
    @trains.push(CargoTrain.new('Грузовой3'))
    @trains.push(CargoTrain.new('Грузовой4'))

    route1 = Route.new(@stations[0], @stations[5])
    route1.add_station(@stations[1], -2)
    route1.add_station(@stations[3], -2)
    route1.add_station(@stations[4], -2)

    @routes.push(route1)
    @routes.push(Route.new(@stations[1], @stations[2]))
    @routes.push(Route.new(@stations[3], @stations[4]))

    train1.route = route1
  end

  protected

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