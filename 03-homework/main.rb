require 'sinatra'
require './db_connector'

get '/messages' do
  erb :message, locals: {
    color: 'antiquewhite',
    name: 'World'
  }
end

get '/messages/:name' do
  name = params['name']
  color = params['color'] ? params['color'] : 'lightslategrey'
  erb :message, locals: {
    color: color,
    name: name
  }
end

get '/login' do
  erb :form
end

post '/login' do
  if params['username'] == 'admin' && params['password'] == 'admin'
    return 'Logged in!'
  else
    redirect '/login'
  end
end

get '/' do
  items = get_all_items_and_categories
  erb :index, locals: {
    items: items
  }
end

get '/create' do
  erb :create
end

post '/create' do
  name = params['item_name']
  price = params['item_price']
  create_new_item(name, price)
  redirect '/'
end

get '/:id' do
  id = params['id']
  item = get_item_detail(id)
  erb :detail, locals: {
    item: item
  }
end

get '/:id/edit' do
  id = params['id']
  item = get_item_detail(id)
  erb :edit, locals: {
    item: item
  }
end

put '/:id' do
  name = params['item_name']
  price = params['item_price']
  id = params['id']
  edit_item(id, name, price)
  redirect '/#{id}'
end

delete '/:id' do
  delete_item(params['id'])
  redirect '/'
end
