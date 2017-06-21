require 'spec_helper'

RSpec.describe Discounter do
  context "determine validity of calculator" do

    before(:all) do
      @ref = build_list(:ticket, 5, price: 100, location: 'OK')
      @discounted = build_list(:ticket, 5, price: 99, location: 'OK')
      @alternating_prices = [Ticket.new(99,'OK'),Ticket.new(100,'OK'),Ticket.new(99,'OK'),Ticket.new(100,'OK'),Ticket.new(99,'OK')]
    end
    
    before(:each) do
      @source = build_list(:ticket, 5, price: 100, location: 'OK')
      @dest = build_list(:ticket, 5, price: 100, location: 'OK')
    end

    it "access entire list apply $0 discount on itself" do
      calculator = Discounter.new("Useless $0 discount", 1, 0)
      calculator.calculate(@source, @source)
      expect(@source).to eq(@ref)
    end

    it "perform a discount on the entire list" do
      calculator = Discounter.new("Boring $1 discount", 1, 1)
      calculator.calculate(@source, @source)
      expect(@source).to eq(@discounted)
    end

    it "perform a discount on every other item in list" do
      calculator = Discounter.new("Alternating", 2, 1)
      calculator.calculate(@source, @source)
      expect(@source).to eq(@alternating_prices)
    end

    it "perform a discount when list is greater than 3" do
      calculator = Discounter.new("Bulk discount, low cutoff", 1, 1, lambda {|x| x.length > 3})
      calculator.calculate(@source, @source)
      expect(@source).to eq(@discounted)
    end

    it "don't perform a discount when list is smaller than 6" do
      calculator = Discounter.new("Bulk discount, high cutoff", 1, 1, lambda {|x| x.length > 5})
      calculator.calculate(@source, @source)
      expect(@source).to eq(@dest)
    end

    it "perform a discount on dest by element of list" do
      calculator = Discounter.new("Perform discount on dest by source", 1, 1)
      calculator.calculate(@source, @dest)
      expect(@dest).to eq(@discounted)
      expect(@source).to eq(@ref)
    end

    it "perform discount on smaller dest" do
      calculator = Discounter.new("Perform discount on small dest", 1, 1)
      small_dest = build_list(:ticket,3)
      small_disc = build_list(:ticket,3, price: 99)
      calculator.calculate(@source, small_dest)
      expect(small_dest).to eq(small_disc)
    end

    it "perform discount on a larger dest" do
      calculator = Discounter.new("Perform discount on large dest", 1, 1)
      large_dest = build_list(:ticket,10)
      ref = build_list(:ticket,5, price: 99) + large_dest[0..4]
      calculator.calculate(@source, large_dest)
      expect(large_dest).to eq(ref)
    end
  end
end
