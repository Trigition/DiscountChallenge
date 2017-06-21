require 'factory_girl'
require_relative '../models/discounter'
require_relative '../models/ticket'
require_relative '../models/sales'
require_relative '../models/customer'
require_relative 'unit/discounter_spec'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end
