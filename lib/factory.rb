# * Here you must define your `Factory` class.
# * Each instance of Factory could be stored into variable. The name of this variable is the name of created Class
# * Arguments of creatable Factory instance are fields/attributes of created class
# * The ability to add some methods to this class must be provided while creating a Factory
# * We must have an ability to get/set the value of attribute like [0], ['attribute_name'], [:attribute_name]
#
# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?
require 'pry'

class Factory 
 def self.new(*args, &block)
    raise ArgumentError, "Wrong number of arguments (0 for 1+)" if args.length < 1

    Class.new do
      attr_accessor(*args)
      class_eval(&block) if block_given?

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

      define_method(:members) do 
        instance_variables.map { |instance_var| instance_var.to_s.delete('@').to_sym}
      end

      define_method(:each) do |&block|
        block ? members.each { |attribute| block.call(send(attribute)) } : enum_for(:each)
      end

      define_method(:each_pair) do |&block|
        block ? to_h.each_pair(&block) : enum_for(:each)
      end

      define_method(:length) do
        self.instance_variables.size
      end

      define_method(:select) do |&block|
        block ? values.select(&block) : enum_for(:select)
      end

      define_method(:values) do
        instance_variables.map { |var| instance_variable_get(var) }
      end

      define_method(:values_at) do |key, value|
        res = values_at(key, value)
      end

      define_method(:==) do |obj|
        self.class == obj.class && self.values == obj.values
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

      alias :to_a :values
      alias :size :length
    end
  end
end
