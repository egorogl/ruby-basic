# frozen_string_literal: true

# Validate vars module
module Validate
  def self.included(base)
    base.extend ClassAndInstanceMethods
    base.send :include, ClassAndInstanceMethods
  end

  # Module ClassAndInstanceMethods
  module ClassAndInstanceMethods
    def validate_variable(text_error, text_error_params = nil)
      raise format(text_error, text_error_params) if yield
    end
  end
end
