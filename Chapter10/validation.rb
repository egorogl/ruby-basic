# frozen_string_literal: true

# Validation module
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # ClassMethods module
  module ClassMethods
    attr_reader :validate_rules

    def validate(sym, type_validation, param = nil)
      @validate_rules ||= {}
      @validate_rules[sym] ||= {}
      @validate_rules[sym][type_validation] = param
    end
  end

  # InstanceMethods module
  module InstanceMethods
    def validate!
      rules = self.class.validate_rules
      local_vars = instance_variables.map { |var| var.to_s.delete('@') }
      rules.each_pair do |attr, type_validation|
        next unless local_vars.include?(attr.to_s)

        type_validation.each_pair do |type, param|
          method = "validate_#{type}"
          send method, attr, param if private_methods.include?(method.to_sym)
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate_presence(attr, _param = nil)
      val = instance_variable_get("@#{attr}")
      if val.nil? || (val.is_a?(String) && val.empty?)
        raise "Переменная #{attr} содержит nil или пустую строку"
      end
    end

    def validate_format(attr, param)
      val = instance_variable_get("@#{attr}")
      raise "Переменная #{attr} не соответствует формату" if val.to_s !~ param
    end

    def validate_type(attr, param)
      val = instance_variable_get("@#{attr}")
      raise "Переменная #{attr} не типа #{param}" unless val.is_a?(param)
    end
  end
end