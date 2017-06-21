FactoryGirl.define do
  factory :ticket do
    price 100
    location 'OK'
  end
  
  factory :discounter do
    name "Default discount"
    iterator 1
    price_deduction 10
  end
end
