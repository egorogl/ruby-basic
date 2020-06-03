# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'wagon'
require_relative 'route'
require_relative 'validate'
require_relative 'acсessors'
require_relative 'validation'

# rubocop:disable Metrics/ClassLength
# Train class
class Train
  include Manufacturer
  include InstanceCounter
  include Validate
  include Accessors
  include Validation

  VALID_TRAIN_TYPES = {
    passenger: 'пассажирский',
    cargo: 'грузовой'
  }.freeze
  REGEXP_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze
  NUMBER_FORMAT_TEXT =
    "Формат номера поезда:\nтри буквы или цифры в любом порядке, "\
    "необязательный дефис\nи еще 2 буквы или цифры после дефиса"
  ERRORS = {
    wagon_class: 'Вагон должен быть классом Wagon, а не %s',
    route_class: 'Маршрут должен быть классом Route, а не %s',
    attach_on_move: 'Нельзя прицепить вагон на ходу, скорость поезда %s',
    detach_on_move: 'Нельзя отцепить вагон на ходу, скорость поезда %s',
    wagon_type: 'Вы пытаетесь прицепить вагон типа %s к поезду типа %s',
    empty_wagons: 'У поезда нет вагонов',
    route_nil: 'У поезда не назначен маршрут',
    bound_station: 'Это и так %s станция',
    invalid_number_format: "Неверный формат номера поезда\n%s",
    train_type: 'Неверно задан тип поезда, доступные значения: %s',
    speed_numeric: 'Скорость поезда должна быть числом',
    block_each: 'Не передан блок в инстанс метод %s#each_with_index_wagons',
    block_each_wagons: 'Не передан блок в инстанс метод %s#each_wagons'
  }.freeze

  attr_accessor_with_history :speed
  attr_reader :number, :current_station, :type, :route, :wagons

  validate :number, :format, REGEXP_NUMBER_FORMAT
  validate :speed, :type, Integer

  # rubocop:disable Style/ClassVars
  @@trains = []
  # rubocop:enable Style/ClassVars

  def initialize(number, type)
    @speed = 0
    @number = number
    @type = type

    local_validate!

    validate!

    register_instance

    @route = nil
    @current_station = nil
    @wagons = []
    @@trains.push(self)
  end

  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def self.each(&block)
    @@trains.each(&block)
  end

  def to_s
    "Поезд: #{number}, тип: #{VALID_TRAIN_TYPES[type]}, "\
    "скорость: #{speed}, вагонов: #{count_wagons}"
  end

  def each_with_index_wagons
    validate_variable(ERRORS[:block_each], self.class) { !block_given? }

    wagons.each_with_index { |wagon, index| yield wagon, index }
  end

  def each_wagons
    validate_variable(ERRORS[:block_each_wagons], self.class) { !block_given? }

    wagons.each { |wagon| yield wagon }
  end

  def stop
    self.speed = 0
  end

  def attach_wagon(wagon)
    validate_attach_wagon(wagon)

    @wagons.push(wagon)
  end

  def detach_wagon(wagon)
    validate_detach_wagon(wagon)

    @wagons.delete(wagon)
  end

  def count_wagons
    @wagons.size
  end

  def route=(route)
    unless route.is_a?(Route)
      raise ArgumentError, ERRORS[:route_class, route.class]
    end

    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
  end

  def goto_next_station
    station = next_station

    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
    @current_station
  rescue RuntimeError
    raise
  end

  def goto_prev_station
    station = prev_station

    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
    @current_station
  rescue RuntimeError
    raise
  end

  protected

  def next_station
    raise ERRORS[:route_nil] unless @route

    index_next_station_in_route = @route.stations.index(@current_station) + 1

    if index_next_station_in_route > @route.stations.size - 1
      raise format(ERRORS[:bound_station], 'конечная')
    end

    @route.stations[index_next_station_in_route]
  end

  def prev_station
    raise ERRORS[:route_nil] unless @route

    index_prev_station_in_route = @route.stations.index(@current_station) - 1

    if index_prev_station_in_route.negative?
      raise format(ERRORS[:bound_station], 'начальная')
    end

    @route.stations[index_prev_station_in_route]
  end

  def sibling_stations
    raise ERRORS[:route_nil] unless @route

    [prev_station, @current_station, next_station]
  end

  private

  def local_validate!
    validate_variable(ERRORS[:train_type], VALID_TRAIN_TYPES.keys) do
      !VALID_TRAIN_TYPES.include?(type)
    end
  end

  def validate_attach_wagon(wagon)
    wagon_type = wagon.type
    train_speed = speed
    validate_variable(ERRORS[:wagon_class], wagon.class) { !wagon.is_a?(Wagon) }
    validate_variable(ERRORS[:attach_on_move], train_speed) { train_speed != 0 }
    validate_variable(ERRORS[:wagon_type],
                      [wagon_type, type]) { wagon_type != type }
  end

  def validate_detach_wagon(wagon)
    validate_variable(ERRORS[:empty_wagons]) { @wagons.empty? }
    validate_variable(ERRORS[:wagon_class], wagon.class) { !wagon.is_a?(Wagon) }
    validate_variable(ERRORS[:detach_wagon], speed) { !speed.zero? }
  end
end
# rubocop:enable Metrics/ClassLength
