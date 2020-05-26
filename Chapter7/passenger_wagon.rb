# frozen_string_literal: true

require_relative 'wagon'

# PassengerWagon class
class PassengerWagon < Wagon
  def initialize
    super(:passenger)
  end
end
