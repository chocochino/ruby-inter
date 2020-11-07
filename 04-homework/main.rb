require 'sinatra'
require './controllers/category_controller.rb'
require './controllers/item_controller.rb'

# Category routes

get '/categories' do
  controller = CategoryController.new
  controller.index
end

get '/categories/new' do
  controller = CategoryController.new
  controller.new_category
end

get '/categories/:id' do
  controller = CategoryController.new
  controller.show(params["id"])
end

post '/categories' do
  controller = CategoryController.new
  controller.create(params)
end

delete '/categories/:id' do
  controller = CategoryController.new
  controller.delete(params["id"])
end

get '/categories/:id/edit' do
  controller = CategoryController.new
  controller.edit(params["id"])
end

put '/categories/:id' do
  controller = CategoryController.new
  controller.update(params)
end

# Items routes

get '/items' do
  controller = ItemController.new
  controller.index
end

get '/items/new' do
  controller = ItemController.new
  controller.new_item
end

get '/items/:id' do
  controller = ItemController.new
  controller.show(params["id"])
end

post '/items' do
  controller = ItemController.new
  controller.create(params)
end

delete '/items/:id' do
  controller = ItemController.new
  controller.delete(params["id"])
end

get '/items/:id/edit' do
  controller = ItemController.new
  controller.edit(params["id"])
end

put '/items/:id' do
  controller = ItemController.new
  controller.update(params)
end

get '/' do
  return 'Go to /categories or /items please'
end
