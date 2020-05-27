# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'wagon'
require_relative 'route'

# Train class
class Train
  include Manufacturer
  include InstanceCounter

  VALID_TRAIN_TYPES = %i[passenger cargo].freeze
  REGEXP_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i.freeze
  NUMBER_FORMAT_TEXT = "Формат номера поезда:\nтри буквы или цифры в любом порядке, необязательный дефис\nи еще 2 буквы или цифры после дефиса"

  attr_accessor :speed
  attr_reader :number, :current_station, :type, :route, :wagons

  @@trains = []

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def stop
    self.speed = 0
  end

  def attach_wagon(wagon)
    raise ArgumentError, "Вагон должен быть классом Wagon, а не #{wagon.class}" unless wagon.is_a?(Wagon)
    raise "Нельзя прицепить вагон на ходу, скорость поезда #{speed}" unless speed.zero?
    raise "Вы пытаетесь прицепить вагон типа #{wagon.type} к поезду типа #{type}" unless wagon.type == type

    @wagons.push(wagon)
  end

  def detach_wagon(wagon)
    raise 'У поезда нет вагонов' if @wagons.empty?
    raise ArgumentError, "Вагон должен быть классом Wagon, а не #{wagon.class}" unless wagon.is_a?(Wagon)
    raise "Нельзя отцепить вагон на ходу, скорость поезда #{speed}" unless speed.zero?

    @wagons.delete(wagon)
  end

  def count_wagons
    @wagons.size
  end

  def route=(route)
    raise ArgumentError, "Маршрут должен быть классом Route, а не #{route.class}" unless route.is_a?(Route)

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

  # Методы ниже, не используются в клиентском коде, хотя и полезные, чтобы просто
  # посмотреть станции рядом, без перемещения. Перемещено в секцию protected
  # ради самого задания.

  def next_station
    raise 'У поезда не назначен маршрут' if @route.nil?

    index_next_station_in_route = @route.stations.index(@current_station) + 1

    raise 'Это и так конечная станция' if index_next_station_in_route > @route.stations.size - 1

    @route.stations[index_next_station_in_route]
  end

  def prev_station
    raise 'У поезда не назначен маршрут' if @route.nil?

    index_prev_station_in_route = @route.stations.index(@current_station) - 1

    raise 'Это и так начальная станция' if index_prev_station_in_route.negative?

    @route.stations[index_prev_station_in_route]
  end

  def sibling_stations
    raise 'У поезда не назначен маршрут' if @route.nil?

    [prev_station, @current_station, next_station]
  end

  private

  def validate!
    raise "Неверный формат номера поезда\n#{NUMBER_FORMAT_TEXT}" if number !~ REGEXP_NUMBER_FORMAT
    raise "Неверно задан тип поезда, доступные значения: #{VALID_TRAIN_TYPES}" unless VALID_TRAIN_TYPES.include?(type)
    raise 'Скорость поезда должна быть числом' unless speed.is_a?(Numeric)
  end
end
