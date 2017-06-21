require_relative 'ticket'
require_relative 'ticket_prices'
require_relative 'sales'

class Customer
  attr_accessor :id
  attr_accessor :tickets
  
  def initialize(id)
    self.id = id
    self.tickets = []
  end

  def add_ticket(ticket)
    self.tickets.push(ticket)
  end

  def get_checkout_prices(sales)
    default_price = sales.get_total(self.tickets)
    sales.apply_all_discounts(self.tickets)
    total = sales.get_total(self.tickets)
    return {"Price" => default_price, "Discount" => default_price - total, "Amount Owed" => total}
  end

  def self.load_ticket_file(filename)
    customers = Hash.new
    File.readlines(filename).each do |line|
      Customer.load_customer(line, customers)
    end
    customers
  end

  def self.load_customer(file_line, customers)
    # Sanitize newlines
    file_line.gsub("\n", '')
    
    # Tokenize string by whitespace
    tokens = file_line.gsub(/\s+/m, ' ').strip.split(" ")
    customer_id = tokens[0] # Customer ID is always at the beginning
    ticket_loc = tokens.drop(1) # Rest of line denotes ticket locations
    customer = nil
    
    # Check if customer already exists
    if customers.key?(customer_id)
      customer = customers[customer_id]
    else
      customer = Customer.new(customer_id)
      customers[customer_id] = customer
    end
    
    # Load tickets
    ticket_loc.each do |location|
      ticket = Ticket.new(TicketPrices::TICKET_PRICES[location], location)
      customer.add_ticket(ticket)
    end
  end
end
