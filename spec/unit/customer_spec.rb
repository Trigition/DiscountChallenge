require 'spec_helper'

RSpec.describe Customer do
  context "determine validity of customer" do
    it "attempts to load a line of data" do
      results = Hash.new
      Customer.load_customer("1 A B C D\n",results)
      customer = results["1"]
      tickets = customer.tickets
      expect(tickets[0].location).to eq("A")
      expect(tickets[1].location).to eq("B")
      expect(tickets[2].location).to eq("C")
      expect(tickets[3].location).to eq("D")
    end

    it "attempts to load a file of data" do
      results = Customer.load_ticket_file("input.in")
      expect(results["1"].id).to eq("1")
      expect(results["2"].id).to eq("2")
    end

    it "check ticket prices from ticket file" do
      results = Customer.load_ticket_file("input.in")
      sales = Sales.new
      sales.add_sale("OH 3 for 2 discount", 3, 'OH', 'OH', 300)
      sales.add_sale("Free SK for every OH", 1, 'OH', 'SK', 30)
      sales.add_sale("BC bulk discount", 1, 'BC', 'BC', 20){|x| x.length > 4}
      customer_1 = results["1"]
      customer_2 = results["2"]
      sales.apply_all_discounts(customer_1.tickets)
      sales.apply_all_discounts(customer_2.tickets)
      expect(sales.get_total(customer_1.tickets)).to eq(1440)
      expect(sales.get_total(customer_2.tickets)).to eq(300)
    end
  end
end
