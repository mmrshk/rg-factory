# frozen_string_literal: true

class ExistingClassError < StandardError
  def message
    'The class with such name exists'
  end
end
