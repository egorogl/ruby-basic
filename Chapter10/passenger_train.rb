# frozen_string_literal: true

require_relative 'train'
require_relative 'validation'

# PassengerTrain class
class PassengerTrain < Train
  include Validation

  validate :number, :format, REGEXP_NUMBER_FORMAT
  validate :speed, :type, Integer

  def initialize(number)
    super(number, :passenger)
  end
end
