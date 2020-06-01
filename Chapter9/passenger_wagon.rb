# frozen_string_literal: true

require_relative 'wagon'

# PassengerWagon class
class PassengerWagon < Wagon
  attr_reader :seats
  attr_accessor :busy_seats

  def initialize(seats)
    @seats = seats
    @busy_seats = 0
    super(:passenger)

    validate!
  end

  def take_seat
    raise 'Нет свободных мест' if busy_seats >= seats

    self.busy_seats += 1
  end

  def free_seats
    seats - busy_seats
  end

  private

  def validate!
    raise 'Количество мест должно быть указано целым числом' unless seats.is_a?(Integer)
    raise 'Количество занятых место больше, чем мест в вагоне' if busy_seats > seats

    super
  end
end
