require_relative 'factory'
=begin
Customer = Factory.new(:name, :address, :zip)
joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
puts joe.name
puts joe['name']
puts joe[:name]
puts joe[0]
puts joe.zip = 90210
puts joe['zip'] = 10101
puts joe[:zip] = 54321
puts joe[2] = 98745
Customer1 = Struct.new(:name, :address) do
 def greeting
   "Hello #{name}!"
 end
end
puts Customer1.new('Dave', '123 Main').greeting
Factory.new('Customer', :name, :address)
customer = Factory::Customer.new('Dave', '123 Main')
Customer = Factory.new(:name, :address, :zip)
joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
each_elements = []
joe.each_pair { |name, value| puts each_elements << "#{name} => #{value}" }

Customer = Factory.new(:a)
c = Customer.new(Customer.new(b: [1, 2, 3]))
puts c.dig(:a, :a, :b, 0)
#binding.pry
puts c.dig(:b, 0)
puts c.dig(:a, :a, :b, :c)
=end
Customer = Factory.new(:name, :address, :zip)
joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12_345)
each_elements = []
joe.each_pair { |name, value| puts each_elements << "#{name} => #{value}" }
