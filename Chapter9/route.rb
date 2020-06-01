# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'
require_relative 'validate'

# Route class
class Route
  include InstanceCounter
  include Validate

  ERRORS = {
    station_not_class: '%s станция должна быть классом Station, а не %s',
    index_not_integer: 'Индекс должен быть целым числом',
    index_outbound: 'Индекс выходит за допустимые пределы',
    delete_extreme_station: 'Нельзя удалить начальную или конечную станцию'
  }.freeze

  attr_reader :stations

  def initialize(from, to)
    validate_variable(ERRORS[:station_not_class], ['Начальная', from.class]) do
      !from.is_a?(Station)
    end

    validate_variable(ERRORS[:station_not_class], ['Конечная', from.class]) do
      !to.is_a?(Station)
    end

    register_instance

    @stations = [from, to]
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
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

  def validate!
    # TODO: For later
  end

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
