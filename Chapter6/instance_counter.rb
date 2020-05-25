# frozen_string_literal: true

# Module InstanceCounter
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # Module ClassMethods
  module ClassMethods
    def instances
      @instances.nil? ? 0 : @instances
    end

    def add_instance
      @instances = 0 if @instances.nil?

      @instances += 1
    end
  end

  # Module InstanceMethods
  module InstanceMethods
    private

    def register_instance
      self.class.add_instance
    end
  end
end