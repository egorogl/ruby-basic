# frozen_string_literal: true

require_relative 'manufacturer'

# Wagon class
class Wagon
  include Manufacturer

  VALID_WAGON_TYPES = {
    passenger: 'пассажирский',
    cargo: 'грузовой'
  }.freeze

  attr_reader :type

  def initialize(type)
    raise ArgumentError, "Неверно передан тип вагона, доступные значения: #{VALID_WAGON_TYPES.keys}" unless VALID_WAGON_TYPES.include?(type)

    @type = type
  end

  def to_s
    "Вагон типа: #{VALID_WAGON_TYPES[type]}"
  end

  # Тут смысла в этом методе нет, т.к. нельзя создать
  # невалидный объект, и менять напрямую тоже ничего нельзя
  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  private

  def validate!
    # Оставлю метод на будущее
  end
end
