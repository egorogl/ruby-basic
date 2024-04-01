# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'
require_relative 'validate'
require_relative 'validation'

# Route class
class Route
  include InstanceCounter
  include Validate
  include Validation

  ERRORS = {
    index_not_integer: 'Индекс должен быть целым числом!',
    index_outbound: 'Индекс выходит за допустимые пределы',
    delete_extreme_station: 'Нельзя удалить начальную или конечную станцию'
  }.freeze

  attr_reader :stations

  validate :from, :type, Station
  validate :to, :type, Station

  def initialize(from, to)
    @from = from
    @to = to

    validate!

    register_instance

    @stations = [from, to]
  end

  def add_station(station, insert_index)
    validate_add_station(station, insert_index)

    @stations.insert(insert_index, station)
  end

  def delete_station(station)
    validate_variable(ERRORS[:station_not_class],
                      ['Переданая', station.class]) do
      !station.is_a?(Station)
    end

    validate_variable(ERRORS[:delete_extreme_station]) do
      @stations.index(station).zero? ||
        @stations.index(station) == (@stations.size - 1)
    end

    @stations.delete(station)
  end

  def display_stations
    print 'Маршрут следования: '
    @stations.each do |station|
      print station.name
      print ' -> ' if station != @stations.last
    end
    puts
  end

  private

  def validate_add_station(station, insert_index)
    validate_variable(ERRORS[:station_not_class],
                      ['Переданая', station.class]) do
      !station.is_a?(Station)
    end
    validate_variable(ERRORS[:index_not_integer]) do
      !insert_index.is_a?(Integer)
    end
    validate_variable(ERRORS[:index_outbound]) do
      (-1..0).include?(insert_index) || insert_index > stations.size
    end
  end
end
