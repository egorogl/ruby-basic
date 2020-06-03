# frozen_string_literal: true

require_relative 'wagon'
require_relative 'acсessors'
require_relative 'validation'

# PassengerWagon class
class PassengerWagon < Wagon
  include Accessors
  include Validation

  ERRORS = {
    no_free_seats: 'Нет свободных мест'
  }.freeze

  attr_reader :seats
  attr_accessor_with_history :busy_seats

  validate :seats, :type, Integer

  def initialize(seats)
    @seats = seats
    @busy_seats = 0
    super(:passenger)

    validate!
  end

  def take_seat
    raise ERRORS[:no_free_seats] if busy_seats >= seats

    self.busy_seats += 1
  end

  def free_seats
    seats - busy_seats
  end
end
