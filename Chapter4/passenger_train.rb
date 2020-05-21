# frozen_string_literal: true

# PassengerTrain class
class PassengerTrain < Train
  def initialize(number)
    super(number, :passenger)
  end
end