# frozen_string_literal: true

require_relative 'instance_counter'

# Station class
class Station
  include InstanceCounter

  attr_reader :name

  @@stations = []

  def initialize(name)
    register_instance

    @name = name
    @trains = []
    @@stations.push(self)
  end

  def self.all
    @@stations
  end

  def take_train(train)
    @trains.push(train)
  end

  def send_train(train)
    @trains.delete(train)
  end

  def get_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end
