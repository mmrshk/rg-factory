require 'pry'
require_relative 'errors/empty_string_error'
require_relative 'errors/existing_class_error'

class Factory
  class << self
    def new(*args, &block)
      raise ExistingClassError if args.first.is_a? Class

      if args.first.is_a? String
        raise EmptyStringError if args.first.empty?

        return const_set(args.shift.capitalize, new(*args, &block))
      end
      build_class(*args, &block)
    end

    def build_class(*args, &block)
      Class.new do
        attr_accessor(*args)

        define_method(:initialize) do |*arg|
          raise ArgumentError, 'Extra args passed then needs' unless args.count == arg.count
          raise NameError, 'Identifier needs to be constant' if args.reject { |arg| arg.is_a? Symbol }.any?

          args.each_index do |i|
            instance_variable_set("@#{args[i]}", arg[i])
          end
        end

        define_method(:[]=) do |arg, value|
          return instance_variable_set("@#{arg}", value) if [String, Symbol].include? arg.class

          instance_variable_set(instance_variables[arg], value) if arg.is_a? Integer
        end

        define_method(:[]) do |arg|
          return instance_variable_get("@#{arg}") if [String, Symbol].include? arg.class

          instance_variable_get(instance_variables[arg]) if arg.is_a? Integer
        end

        define_method(:members) do
          instance_variables.map { |var| var.to_s.delete('@').to_sym }
        end

        define_method(:each) do |&block|
          members.each { |attr| block.call(public_send(attr)) }
        end

        define_method(:each_pair) do |&block|
          to_h.each_pair(&block)
        end

        define_method(:length) do
          instance_variables.size
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
          self.class == obj.class && (values.eql? obj.values)
        end

        define_method(:to_h) do
          Hash[members.zip(values)]
        end

        define_method(:dig) do |*args|
          args.reduce(to_h) do |hash, key|
            return unless hash[key]

            hash[key]
          end
        end

        class_eval(&block) if block_given?
        alias :== :eql?
        alias :to_a :values
        alias :size :length
      end
    end
  end
end
