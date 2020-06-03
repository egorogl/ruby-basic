# frozen_string_literal: true

require_relative 'train'
require_relative 'validation'

# CargoTrain class
class CargoTrain < Train
  include Validation

  validate :number, :format, REGEXP_NUMBER_FORMAT
  validate :speed, :type, Integer

  def initialize(number)
    super(number, :cargo)
  end
end
