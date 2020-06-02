# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'train'
require_relative 'validate'

# Station class
class Station
  include InstanceCounter
  include Validate

  ERRORS = {
    train_type: 'Неверно передан тип поезда, доступные значения: %s',
    empty_name: 'Название станции не должно быть пустым',
    name_exist: 'Станция с именем %s уже есть',
    train_class: 'Поезд должен быть классом Train, а не %s',
    block_each: 'Не передан блок в %s.each',
    block_each_trains: 'Не передан блок в инстанс метод %s#each_trains'
  }.freeze

  attr_reader :name, :trains

  class << self
    attr_accessor :stations
  end

  @stations = []

  def initialize(name)
    name = name.to_s

    validate_variable(ERRORS[:empty_name]) { name.empty? }
    validate_variable(ERRORS[:name_exist], name) do
      self.class.stations.detect { |station| station.name == name }
    end

    register_instance

    @name = name
    @trains = []
    self.class.stations.push(self)
  end

  def self.all
    stations
  end

  def self.each
    validate_variable(ERRORS[:block_each], self) { !block_given? }

    stations.each { |station| yield station }
  end

  def each_trains
    validate_variable(ERRORS[:block_each_trains], self.class) { !block_given? }

    trains.each { |train| yield train }
  end

  def to_s
    "Станция: #{name}, поездов на станции: #{trains.size}"
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def take_train(train)
    validate_variable(ERRORS[:train_class], train.class) { !train.is_a?(Train) }

    @trains.push(train)
  end

  def send_train(train)
    validate_variable(ERRORS[:train_class], train.class) { !train.is_a?(Train) }

    @trains.delete(train)
  end

  def get_trains_by_type(type)
    validate_variable(ERRORS[:train_type], Train::VALID_TRAIN_TYPES.keys) do
      !Train::VALID_TRAIN_TYPES.include?(type)
    end

    @trains.select { |train| train.type == type }
  end

  private

  def validate!
    # TODO: For later
  end
end
