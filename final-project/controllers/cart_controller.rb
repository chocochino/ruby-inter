require './models/order.rb'
require './models/item_order.rb'
require './models/item.rb'
require './models/customer.rb'
require 'date'

class CartController

  def index
    cart = Order.get_empty_order
    cart.item_orders = ItemOrder.get_one(cart.id)
    customers = Customer.get_all
    renderer = ERB.new(File.read('./views/cart.erb'))
    renderer.result(binding)
  end

  def create
    cart = Order.get_empty_order
    unless cart.nil?
      Order.delete(cart.id)
      ItemOrder.clear(cart.id)
    end
    cart = Order.new(:order_date => Date.today)
    cart.save
  end

  def add_item(item_id)
    cart = Order.get_empty_order
    item_id = item_id.to_i
    to_update = nil
    unless cart.item_orders.empty? then
      cart.item_orders.each {|io| to_update = io if io.item.id == item_id }
      unless to_update.nil? then
        to_update.quantity += 1
        to_update.item = item_id
        return to_update.update
      end
    end
    to_update = ItemOrder.new(:item => item_id) if to_update.nil?
    to_update.save  
  end

  def remove_item(item_id)
    cart = Order.get_empty_order
    ItemOrder.delete(cart.id, item_id)
  end

  def checkout(params)
    cart = Order.get_empty_order
    order = Order.new(
      :id => cart.id,
      :order_date => params["order_date"],
      :is_complete => 1,
      :customer => params["customer"]
    )
    
    if order.update then
      assign_item_orders(params, order.id)
      create
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def assign_item_orders(params, order_id)
    params.each do |key, data|
      if key.include?('quantity') then
        array = key.split('_')
        item_order = ItemOrder.new(
          :order_id => order_id,
          :item => array[-2],
          :price_each => array.last,
          :quantity => data
        )
      end
    end
  end
end
