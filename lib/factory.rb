class Factory 
 def self.new(*args)
    Class.new do
      attr_accessor(*args)

      define_method(:initialize) do |*arg|
        args.each_index do |i|
          unless args[i].is_a? Symbol
            raise NameError, "Identifier #{args[i]} needs to be constant"
          end
          instance_variable_set("@#{args[i]}", arg[i])
        end
      end

      define_method(:[]=) do |arg, value|
        if (arg.is_a? String) || (arg.is_a? Symbol)
          instance_variable_set("@#{arg}", value)
        elsif arg.is_a? Integer
          instance_variable_set(instance_variables[arg], value)
        end
      end

      define_method(:[]) do |arg|
        if (arg.is_a? String) || (arg.is_a? Symbol)
          instance_variable_get("@#{arg}")
        elsif arg.is_a? Integer
          instance_variable_get(instance_variables[arg])
        end
      end
    end
  end
end
