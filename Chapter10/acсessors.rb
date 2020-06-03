# frozen_string_literal: true

# Accessors module
module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  # ClassMethods module
  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        define_method(method) do
          instance_variable_get("@#{method}")
        end
        define_method("#{method}=") do |v|
          instance_variable_set("@#{method}", v)
          send "#{method}_history=", v
        end

        define_method("#{method}_history") do
          instance_variable_get("@#{method}_history") || []
        end

        define_method("#{method}_history=") do |v|
          arr = instance_variable_get("@#{method}_history") || []
          arr << v
          instance_variable_set("@#{method}_history", arr)
        end

        send :private, "#{method}_history="
      end
    end

    def strong_attr_accessor(method, klass)
      define_method(method) do
        instance_variable_get("@#{method}")
      end
      define_method("#{method}=") do |v|
        unless v.is_a?(klass)
          raise "Переменная #{method} не соответствует классу #{klass}"
        end

        instance_variable_set("@#{method}", v)
      end
    end
  end
end