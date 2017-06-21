#!/usr/bin/env ruby -i
require_relative 'customer'
require_relative 'sales'

if ARGV[0] == "--help" or ARGV[0] == "-h"
  puts "\n---Use---"
  puts "./main input_filename output_filename"
  exit 0
end

input = ARGV[0]

customers = Customer.load_ticket_file(input)
sales = Sales.new
sales.add_sale("OH 3 for 2 discount", 3, 'OH', 'OH', 300)
sales.add_sale("Free SK for every OH", 1, 'OH', 'SK', 30)
sales.add_sale("BC bulk discount", 1, 'BC', 'BC', 20, 
               lambda {|x| x.length > 4})

print "Customer | Price | Discount | Amount Owed\n" 
customers.each do |id, customer|
  checkout = customer.get_checkout_prices(sales)
  print id.rjust(8) + " |"
  print "%-7.02f| " % checkout["Price"].to_f
  print "%-9.02f| " % checkout["Discount"].to_f
  print "%-7.02f\n" % checkout["Amount Owed"].to_f
end
