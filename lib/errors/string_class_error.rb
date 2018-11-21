# frozen_string_literal: true

class StringClassError < StandardError
  def message
   'First arg isn't a string'
  end
end
