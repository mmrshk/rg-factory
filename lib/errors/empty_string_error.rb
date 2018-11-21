# frozen_string_literal: true

class EmptyStringError < StandardError
  def message
    'The argument is empty'
  end
end
