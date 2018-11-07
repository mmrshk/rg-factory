require_relative 'factory'

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