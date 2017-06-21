require 'spec_helper'

RSpec.describe Sales do
  context "determine validity of sales" do
    before(:each) do
      @sales = Sales.new()
    end

    it "passes in list of tickets but with no discounts" do
      price = 300
      tickets = build_list(:ticket, 10, price: price)
      @sales.apply_all_discounts(tickets)
      expect(@sales.get_total(tickets)).to eq(price*10)
    end

    it "checks OH discount" do
      price = 300
      tickets = build_list(:ticket, 3, location: 'OH', price: price) +
        build_list(:ticket, 1, location: 'BC', price: 110)

      @sales.add_sale("OH Discount", 3, 'OH', 'OH', 300)

      @sales.apply_all_discounts(tickets)

      expect(@sales.get_total(tickets)).to eq(710)
    end

    it "checks for lots of OH discounts" do
      tickets = build_list(:ticket, 6, location: 'OH', price: 300) +
        build_list(:ticket, 2, location: 'BC', price: 110)
      @sales.add_sale("OH Discount", 3, 'OH', 'OH', 300)
      @sales.apply_all_discounts(tickets)
      expect(@sales.get_total(tickets)).to eq(1420)
    end

    it "checks for bulk discounts" do
      tickets = build_list(:ticket, 5, location: 'BC', price: 110)
      @sales.add_sale("BC bulk discount", 1, 'BC', 'BC', 20) {|x| x.length > 4}
      @sales.apply_all_discounts(tickets)
      expect(@sales.get_total(tickets)).to eq(90*5)
    end

    it "checks for non-satisfactory amount for bulk" do
      tickets = build_list(:ticket, 4, location: 'BC', price: 110)
      @sales.add_sale("BC bulk discount", 1, 'BC', 'BC', 20) {|x| x.length > 4}
      @sales.apply_all_discounts(tickets)
      expect(@sales.get_total(tickets)).to eq(110*4)
    end

    it "checks for getting 1 ticket free with purchase of another type" do
      tickets = build_list(:ticket, 3, location: 'OH', price: 300) +
                build_list(:ticket, 10, location: 'SK', price: 30)
      @sales.add_sale("Free SK with every OH", 1, 'OH', 'SK', 30)
      @sales.apply_all_discounts(tickets)
      expect(@sales.get_total(tickets)).to eq(300*3 + 7*30)
    end
  end
end
