require_relative 'ticket'
require_relative 'discounter'

class Sales
  class Selector
    attr_accessor :src_key
    attr_accessor :dest_key
    def initialize(src_key, dest_key)
      self.src_key = src_key
      self.dest_key = dest_key
    end
  end

  attr_accessor :discounts

  def initialize
    self.discounts = []
  end

  # Adds a sale to be used upon checkout
  def add_sale(name, itr, src_key, dest_key, discount_amount,&block)
    new_discount = Discounter.new(name, itr, discount_amount, &block)
    new_selector = Selector.new(src_key, dest_key)
    self.discounts.push({"discount" => new_discount,
                         "selection" => new_selector})
  end

  # Applies all discounts to tickets
  def apply_all_discounts(tickets)
    self.discounts.each do |discount|
      # Get appropriate selection
      source = self.get_selection(discount["selection"].src_key, tickets)
      dest = self.get_selection(discount["selection"].dest_key, tickets)

      # Apply discount
      discounter = discount["discount"]
      discounter.calculate(source, dest)
    end
  end

  def get_selection(selector, tickets)
    selection = []
    # Add each ticket which matches our selection
    tickets.each do |ticket|
      if ticket.location == selector
        selection.push(ticket)
      end
    end
    selection
  end

  def get_total(tickets)
    total = 0
    tickets.each do |ticket|
      total += ticket.calculate_final_price
    end
    total
  end
end
