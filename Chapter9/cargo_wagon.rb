# frozen_string_literal: true

require_relative 'wagon'

# CargoWagon class
class CargoWagon < Wagon
  attr_reader :volume
  attr_accessor :busy_volume

  def initialize(volume)
    @volume = volume
    @busy_volume = 0
    super(:cargo)

    validate!
  end

  def take_volume(volume)
    raise 'Нет свободого места' if busy_volume + volume > self.volume

    self.busy_volume += volume
  end

  def free_volume
    volume - busy_volume
  end

  private

  def validate!
    raise 'Объем свободно места должно быть указано числом' unless volume.is_a?(Numeric)
    raise 'Объем занятого места больше, чем объем вагона' if busy_volume > volume

    super
  end
end
