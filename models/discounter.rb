require_relative 'ticket'

class Discounter
  attr_accessor :name
  attr_accessor :iterator
  attr_accessor :discount_qualifier
  attr_accessor :price_deduction

  def initialize(name, iterator, price_deduction, &block)
    self.name = name
    self.iterator = iterator
    self.price_deduction = price_deduction
    if block_given?
      self.discount_qualifier = block
    else
      self.discount_qualifier = lambda {|tickets_to_apply| return true }
    end
  end



  def calculate(source, dest)
    if self.discount_qualifier.call(source)
      # No guarantee either list is same size, need to bound range of indexer
      max_len = [source.length, dest.length].min - 1
      # Iterate over every nth
      ((self.iterator - 1)..max_len).step(self.iterator).each do |i|
        dest[i].add_adjustment(self.price_deduction, self.name)
      end
    end
  end
end
