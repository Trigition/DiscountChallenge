require_relative 'adjustment'

class Ticket
  attr_accessor :price
  attr_accessor :location
  attr_accessor :adjustments

  def initialize(price=nil, location=nil)
    self.price = price
    self.location = location
    self.adjustments = []
  end

  def add_adjustment(price, reason)
    self.adjustments.push(Adjustment.new(price, reason))
  end

  def calculate_final_price
    total = self.price
    self.adjustments.each do |adjustment|
      total -= adjustment.price_deductor
    end
    total
  end

  def print_ticket
    string = "Price: %.2f" % self.price.to_f
    string += " Location: %s" % self.location
    self.adjustments.each do |adjustment|
      string += " Adjustment: %s " % adjustment.reason
      string += "%d" % adjustment.price_deductor
    end
    string
  end

  def ==(other)
    self.price = other.price and self.location == other.location
  end
end
