require_relative 'ticket'

class Discounter
  attr_accessor :name
  attr_accessor :itr
  attr_accessor :flag
  attr_accessor :discount

  def initialize(name, itr, discount,
                 flag = lambda {|x| return true })
    self.name = name
    self.itr = itr
    self.discount = discount
    self.flag = flag
  end



  def calculate(source, dest)
    if self.flag.call(source)
      # No guarantee either list is same size, need to bound range of indexer
      max_len = [source.length, dest.length].min - 1
      # Iterate over every itr_th
      ((self.itr - 1)..max_len).step(self.itr).each do |i|
        dest[i].add_adjustment(self.discount, self.name)
      end
    end
  end
end
