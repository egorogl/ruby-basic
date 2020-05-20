# frozen_string_literal: true

# Train class
class Train
  attr_accessor :speed
  attr_reader :count_wagons

  def initialize(number, type, count_wagons)
    @number = number
    @type = type
    @count_wagons = count_wagons
    @speed = 0
    @route = nil
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

    route.stations.first.take_train(self)
  end
end

=begin
Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end