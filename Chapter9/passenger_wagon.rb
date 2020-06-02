# frozen_string_literal: true

require_relative 'wagon'

# PassengerWagon class
class PassengerWagon < Wagon
  ERRORS = {
    all_seats_numeric: 'Количество мест должно быть указано целым числом',
    busy_seats_gt_all: 'Количество занятых место больше, чем мест в вагоне',
    no_free_seats: 'Нет свободных мест'
  }.freeze

  attr_reader :seats
  attr_accessor :busy_seats

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

  private

  def validate!
    raise ERRORS[:all_seats_numeric] unless seats.is_a?(Integer)
    raise ERRORS[:busy_seats_gt_all] if busy_seats > seats

    super
  end
end
