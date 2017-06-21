class Adjustment
  attr_accessor :price_deductor
  attr_accessor :reason

  def initialize(price, reason)
    self.price_deductor = price
    self.reason = reason
  end
end
