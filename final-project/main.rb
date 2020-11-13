require 'sinatra'
require './controllers/customer_controller.rb'
require './models/customer.rb'
require './controllers/item_controller.rb'
require './models/item.rb'
require './controllers/category_controller.rb'
require './models/category.rb'

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

get '/customers/:id/edit' do
  controller = CustomerController.new
  controller.edit(params["id"])
end

put '/customers/:id' do
  controller = CustomerController.new
  controller.update(params)
end

delete '/customers/:id' do
  controller = CustomerController.new
  controller.delete(params["id"])
end

# Items

get '/items' do
  controller = ItemController.new
  controller.index
end

get '/items/new' do
  controller = ItemController.new
  controller.new_entry
end

post '/items' do
  controller = ItemController.new
  controller.create(params)
end

get '/items/:id' do
  controller = ItemController.new
  controller.show(params["id"])
end

get '/items/:id/edit' do
  controller = ItemController.new
  controller.edit(params["id"])
end

put '/items/:id' do
  controller = ItemController.new
  controller.update(params)
end

delete '/items/:id' do
  controller = ItemController.new
  controller.delete(params["id"])
end

# Categories

get '/categories' do
  controller = CategoryController.new
  controller.index
end

get '/categories/new' do
  controller = CategoryController.new
  controller.new_entry
end

post '/categories' do
  controller = CategoryController.new
  controller.create(params)
end

get '/categories/:id' do
  controller = CategoryController.new
  controller.show(params["id"])
end

get '/categories/:id/edit' do
  controller = CategoryController.new
  controller.edit(params["id"])
end

put '/categories/:id' do
  controller = CategoryController.new
  controller.update(params)
end

delete '/categories/:id' do
  controller = CategoryController.new
  controller.delete(params["id"])
end
