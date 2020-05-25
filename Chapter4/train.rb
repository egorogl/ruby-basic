# frozen_string_literal: true

# Train class
class Train
  attr_accessor :speed
  attr_reader :count_wagons, :number, :current_station, :type

  def initialize(number, type, count_wagons)
    @number = number
    @type = type
    @count_wagons = count_wagons
    @speed = 0
    @route = nil
    @current_station = nil
  end

  def stop
    self.speed = 0
  end

  def attach_wagon
    @count_wagons += 1 if speed.zero?
  end

  def detach_wagon
    @count_wagons -= 1 if speed.zero? && @count_wagons.positive?
  end

  def route=(route)
    @route = route
    @current_station = @route.stations.first
    @current_station&.take_train(self)
  end

  def goto_next_station
    @current_station.send_train(self)
    @current_station = next_station
    @current_station&.take_train(self)
  end

  def goto_prev_station
    @current_station.send_train(self)
    @current_station = prev_station
    @current_station&.take_train(self)
  end

  def next_station
    return if @route.nil?

    index_next_station_in_route = @route.stations.index(@current_station) + 1

    return if index_next_station_in_route > @route.stations.size - 1

    @route.stations[index_next_station_in_route]
  end

  def prev_station
    return if @route.nil?

    index_prev_station_in_route = @route.stations.index(@current_station) - 1

    return if index_prev_station_in_route.negative?

    @route.stations[index_prev_station_in_route]
  end

  def sibling_stations
    return if @route.nil?

    [prev_station, @current_station, next_station]
  end
end
