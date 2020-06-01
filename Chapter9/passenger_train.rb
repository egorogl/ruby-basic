# frozen_string_literal: true

require_relative 'train'

# PassengerTrain class
class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end
end
