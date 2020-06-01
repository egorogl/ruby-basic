# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'

# rubocop:disable Metrics/MethodLength
# Route class
class Route
  include InstanceCounter

  TEXT_ERRORS = {
    station_not_class: '%s станция должна быть классом Station, а не %s',
    index_not_integer: 'Индекс должен быть целым числом',
    index_outbound: 'Индекс выходит за допустимые пределы',
    delete_extreme_station: 'Нельзя удалить начальную или конечную станцию'
  }.freeze

  attr_reader :stations

  alias display_stations to_s

  def initialize(from, to)
    unless from.is_a?(Station)
      raise ArgumentError, format(
        TEXT_ERRORS[:station_not_class],
        'Начальная', from.class
      )
    end

    unless to.is_a?(Station)
      raise ArgumentError, format(
        TEXT_ERRORS[:station_not_class],
        'Конечная', to.class
      )
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
    unless station.is_a?(Station)
      raise ArgumentError, format(
        TEXT_ERRORS[:station_not_class],
        'Переданая', station.class
      )
    end

    unless insert_index.is_a?(Integer)
      raise ArgumentError, TEXT_ERRORS[:index_not_integer]
    end

    if (-1..0).include?(insert_index) || insert_index > @stations.size
      raise IndexError, TEXT_ERRORS[:index_outbound]
    end

    @stations.insert(insert_index, station)
  end

  def delete_station(station)
    unless station.is_a?(Station)
      raise ArgumentError, format(
        TEXT_ERRORS[:station_not_class],
        'Переданая', station.class
      )
    end

    if @stations.index(station).zero? ||
       @stations.index(station) == (@stations.size - 1)
      raise TEXT_ERRORS[:delete_extreme_station]
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
end
# rubocop:enable Metrics/MethodLength
