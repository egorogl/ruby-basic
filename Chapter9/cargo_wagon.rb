# frozen_string_literal: true

require_relative 'wagon'

# CargoWagon class
class CargoWagon < Wagon
  TEXT_ERRORS = {
    all_volume_numeric: 'Объем свободно места должно быть указано числом',
    busy_volume_gt_all: 'Объем занятого места больше, чем объем вагона',
    no_free_volume: 'Нет свободого места'
  }.freeze

  attr_reader :volume
  attr_accessor :busy_volume

  def initialize(volume)
    @volume = volume
    @busy_volume = 0
    super(:cargo)

    validate!
  end

  def take_volume(occupy)
    raise TEXT_ERRORS[:no_free_volume] if busy_volume + occupy > volume

    self.busy_volume += occupy
  end

  def free_volume
    volume - busy_volume
  end

  private

  def validate!
    raise TEXT_ERRORS[:all_volume_numeric] unless volume.is_a?(Numeric)
    raise TEXT_ERRORS[:busy_volume_gt_all] if busy_volume > volume

    super
  end
end
