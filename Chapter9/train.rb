# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'wagon'
require_relative 'route'

# rubocop:disable Metrics/ClassLength
# Train class
class Train
  include Manufacturer
  include InstanceCounter

  VALID_TRAIN_TYPES = {
    passenger: 'пассажирский',
    cargo: 'грузовой'
  }.freeze
  REGEXP_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze
  NUMBER_FORMAT_TEXT =
    "Формат номера поезда:\nтри буквы или цифры в любом порядке, "\
    "необязательный дефис\nи еще 2 буквы или цифры после дефиса"
  TEXT_ERRORS = {
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
    speed_numeric: 'Скорость поезда должна быть числом'
  }.freeze

  attr_accessor :speed
  attr_reader :number, :current_station, :type, :route, :wagons

  # rubocop:disable Style/ClassVars
  @@trains = []
  # rubocop:enable Style/ClassVars

  def initialize(number, type)
    @speed = 0
    @number = number
    @type = type

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def stop
    self.speed = 0
  end

  # rubocop:disable Metrics/AbcSize
  def attach_wagon(wagon)
    unless wagon.is_a?(Wagon)
      raise ArgumentError, TEXT_ERRORS[:wagon_class, wagon.class]
    end

    raise format(TEXT_ERRORS[:attach_on_move], speed) unless speed.zero?

    unless wagon.type == type
      raise format(TEXT_ERRORS[:wagon_type, wagon.type, type])
    end

    @wagons.push(wagon)
  end
  # rubocop:enable Metrics/AbcSize

  def detach_wagon(wagon)
    raise TEXT_ERRORS[:empty_wagons] if @wagons.empty?

    unless wagon.is_a?(Wagon)
      raise ArgumentError, TEXT_ERRORS[:wagon_class, wagon.class]
    end

    raise format(TEXT_ERRORS[:detach_wagon], speed) unless speed.zero?

    @wagons.delete(wagon)
  end

  def count_wagons
    @wagons.size
  end

  def route=(route)
    unless route.is_a?(Route)
      raise ArgumentError, TEXT_ERRORS[:route_class, route.class]
    end

    @route = route
    @current_station = @route.stations.first
    @current_station.take_train(self)
  end

  def goto_next_station
    begin
      station = next_station
    rescue RuntimeError
      raise
    end

    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
    @current_station
  end

  def goto_prev_station
    begin
      station = prev_station
    rescue RuntimeError
      raise
    end

    @current_station.send_train(self)
    @current_station = station
    @current_station.take_train(self)
    @current_station
  end

  protected

  def next_station
    raise TEXT_ERRORS[:route_nil] unless @route

    index_next_station_in_route = @route.stations.index(@current_station) + 1

    if index_next_station_in_route > @route.stations.size - 1
      raise format(TEXT_ERRORS[:bound_station], 'конечная')
    end

    @route.stations[index_next_station_in_route]
  end

  def prev_station
    raise TEXT_ERRORS[:route_nil] unless @route

    index_prev_station_in_route = @route.stations.index(@current_station) - 1

    if index_prev_station_in_route.negative?
      raise format(TEXT_ERRORS[:bound_station], 'начальная')
    end

    @route.stations[index_prev_station_in_route]
  end

  def sibling_stations
    raise TEXT_ERRORS[:route_nil] unless @route

    [prev_station, @current_station, next_station]
  end

  private

  # rubocop:disable Metrics/AbcSize
  def validate!
    if number !~ REGEXP_NUMBER_FORMAT
      raise format(TEXT_ERRORS[:invalid_number_format], NUMBER_FORMAT_TEXT)
    end

    unless VALID_TRAIN_TYPES.include?(type)
      raise format(TEXT_ERRORS[:train_type], VALID_TRAIN_TYPES.keys)
    end

    raise TEXT_ERRORS[:speed_numeric] unless speed.is_a?(Numeric)
  end
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ClassLength
