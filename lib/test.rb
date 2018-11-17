require_relative 'factory'

h = { foo: {bar: {baz: 1}}}
#puts h.dig(:foo, :bar, :baz)           #=>  1
#puts h.dig(:foo, :zot)

Customer = Factory.new(:a)
c = Customer.new(Customer.new(b: [1, 2, 3]))
puts c
#puts c.dig(:a, :a, :b, 2)
puts c.dig(:b, 0)
#puts c.dig(:a, :a, :b, :c)
