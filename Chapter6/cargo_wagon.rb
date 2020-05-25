# frozen_string_literal: true

require_relative 'wagon'

# CargoWagon class
class CargoWagon < Wagon
  def initialize
    super(:cargo)
  end
end