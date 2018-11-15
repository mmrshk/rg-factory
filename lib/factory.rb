require 'pry'

class Factory
  class << self
    def new(*args, &block)
      Class.new do
        attr_accessor(*args)

        define_method(:initialize) do |*arg|
          raise ArgumentError, 'Extra args passed then needs' unless args.count == arg.count

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

        define_method(:members) do
          instance_variables.map { |var| var.to_s.delete('@').to_sym}
        end

        define_method(:each) do |&block|
          members.each { |attr| block.call(send(attr)) }
        end

        define_method(:each_pair) do |&block|
          to_h.each_pair(&block)
        end

        define_method(:length) do
          self.instance_variables.size
        end

        define_method(:select) do |&block|
          values.select(&block)
        end

        define_method(:values) do
          instance_variables.map { |var| instance_variable_get(var) }
        end

        define_method(:values_at) do |*index|
          instance_variables.values_at(*index).map { |values| instance_variable_get values }
        end

        define_method(:eql?) do |obj|
          self.class == obj.class && (self.values.eql? obj.values)
        end

        define_method(:to_h) do
          res = {}
          b = instance_variables.map {|var| hash = {var => instance_variable_get(var)}}
          b.each do |val|
            val.each do |key, value|
              key = key.to_s.delete('@').to_sym
              res[key] = Hash[key, value]
            end
          end
          res
        end

        define_method(:dig) do |*args|
           to_h.dig(*args)
        end

        class_eval(&block) if block_given?
        alias :== :eql?
        alias :to_a :values
        alias :size :length
      end
    end
  end
end
