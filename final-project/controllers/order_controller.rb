require './models/order.rb'
require './models/item_order.rb'

class OrderController

  def index
    orders = Order.get_all
    renderer = ERB.new(File.read('./views/order/index.erb'))
    renderer.result(binding)
  end

  def show(id)
    order = Order.get_one(id)
    unless order then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/order/show.erb'))
    end
    renderer.result(binding)
  end
  
  # def new_entry
  #   renderer = ERB.new(File.read('./views/order/new.erb'))
  #   renderer.result(binding)
  # end

  # def edit(id)
  #   order = Order.get_one(id)
  #   unless order then
  #     renderer = ERB.new(File.read('./views/error.erb'))  
  #   else
  #     renderer = ERB.new(File.read('./views/order/edit.erb'))
  #   end
  #   renderer.result(binding)
  # end  

  # def create(params)
  #   order = Order.new(
  #     :name => params["name"],
  #     :phone => params["phone"]
  #   )
    
  #   if order.save then
  #     index
  #   else 
  #     renderer = ERB.new(File.read('./views/error.erb'))
  #     renderer.result(binding)
  #   end
  # end

  def update(params)
    order = Order.new(
      :id => params["id"],
      :order_date => params["order_date"],
      :is_complete => params["is_complete"],
      :customer => params["customer"]
    )
    
    if order.update then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def delete(id)
    Order.delete(id)
    index
  end

end
