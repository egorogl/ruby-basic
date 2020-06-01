# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'station'

# Route class
class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(from, to)
    raise ArgumentError, "Начальная станция должна быть классом Station, а не #{from.class}" unless from.is_a?(Station)
    raise ArgumentError, "Конечная станция должна быть классом Station, а не #{to.class}" unless to.is_a?(Station)

    register_instance

    @stations = [from, to]
  end

  # Тут смысла в этом методе нет, т.к. нельзя создать
  # невалидный объект, и менять напрямую тоже ничего нельзя
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station, insert_index)
    raise ArgumentError, "Станция должна быть классом Station, а не #{station.class}" unless station.is_a?(Station)
    raise ArgumentError, 'Индекс должен быть целым числом' unless insert_index.is_a?(Integer)

    unless insert_index != 0 &&
           insert_index < @stations.size &&
           insert_index != -1
      raise IndexError, 'Индекс выходит за допустимые пределы'
    end

    @stations.insert(insert_index, station)
  end

  def delete_station(station)
    raise ArgumentError, "Станция должна быть классом Station, а не #{station.class}" unless station.is_a?(Station)

    unless @stations.index(station) != 0 &&
           @stations.index(station) != (@stations.size - 1)
      raise 'Нельзя удалить начальную или конечную станцию'
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
    # Оставлю метод на будущее
  end
end
