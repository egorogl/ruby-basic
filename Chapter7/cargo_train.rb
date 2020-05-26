# frozen_string_literal: true

require_relative 'train'

# CargoTrain class
class CargoTrain < Train
  def initialize(number)
    super(number, :cargo)
  end
end
