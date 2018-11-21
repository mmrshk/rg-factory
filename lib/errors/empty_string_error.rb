# frozen_string_literal: true

class EmptyArgumentError < StandardError
  def message
    'The argument is empty'
  end
end
