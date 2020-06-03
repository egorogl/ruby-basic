# frozen_string_literal: true

require_relative 'manufacturer'

# Wagon class
class Wagon
  include Manufacturer

  VALID_WAGON_TYPES = {
    passenger: 'пассажирский',
    cargo: 'грузовой'
  }.freeze
  ERRORS = {
    wagon_type: 'Неверно передан тип вагона, доступные значения: %s'
  }.freeze

  attr_reader :type

  def initialize(type)
    unless VALID_WAGON_TYPES.include?(type)
      raise ArgumentError, format(
        ERRORS[:wagon_type], VALID_WAGON_TYPES.keys
      )
    end

    @type = type
  end

  def to_s
    "Вагон типа: #{VALID_WAGON_TYPES[type]}"
  end
end
