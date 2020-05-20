class Train
  attr_accessor :speed
  attr_reader :count_wagons

  def initialize(number, type, count_wagons)
    @number = number
    @type = type
    @count_wagons = count_wagons
    @speed = 0
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
end