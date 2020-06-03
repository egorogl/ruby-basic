# frozen_string_literal: true

require_relative 'wagon'
require_relative 'acсessors'
require_relative 'validation'

# CargoWagon class
class CargoWagon < Wagon
  include Accessors
  include Validation

  ERRORS = {
    no_free_volume: 'Нет свободого места'
  }.freeze

  attr_reader :volume
  attr_accessor_with_history :busy_volume

  validate :volume, :type, Numeric

  def initialize(volume)
    @volume = volume
    @busy_volume = 0
    super(:cargo)

    validate!
  end

  def take_volume(occupy)
    raise ERRORS[:no_free_volume] if busy_volume + occupy > volume

    self.busy_volume += occupy
  end

  def free_volume
    volume - busy_volume
  end
end
