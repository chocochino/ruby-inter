require 'sinatra'
require './controllers/customer_controller.rb'
require './models/customer.rb'

get '/' do
  return 'are you lost?'
end

# Customers

get '/customers' do
  controller = CustomerController.new
  controller.index
end

get '/customers/new' do
  controller = CustomerController.new
  controller.new_entry
end

post '/customers' do
  controller = CustomerController.new
  controller.create(params)
end

get '/customers/:id' do
  controller = CustomerController.new
  controller.show(params["id"])
end
