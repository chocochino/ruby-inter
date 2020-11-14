require './db/mysql_connector.rb'
require './models/item.rb'
require './models/order.rb'

class ItemOrder

  attr_accessor :order_id, :item, :price_each, :quantity

  def initialize(hash)
    @order_id = hash[:order_id]
    @item = hash[:item]
    @price_each = hash[:price_each]
    @quantity = hash[:quantity]
  end

  def self.get_one(order_id)
    client = create_db_client
    raw_data = client.query(
      "select io.order_id, io.item_id, io.price_each, io.quantity, i.name from itemOrders io inner join items i using(item_id) where io.order_id = #{order_id};")
    item_orders = self.convert_query_to_list(raw_data)
  end

  def self.delete(order_id, item_id)
    client = create_db_client
    client.query("delete from itemOrders where order_id = #{order_id} and item_id = #{item_id}")
  end

  def save
    return false unless valid?

    @item = Item.get_one(@item) if @item.is_a? Integer
    @price_each = @item.price if @price_each.nil?
    @quantity = 1 if @quantity.nil?
    @order_id = Order.get_empty_order.id if @order_id.nil?
    
    client = create_db_client
    client.query("insert into itemOrders(order_id, item_id, price_each, quantity) values (#{@order_id}, #{@item.id}, #{@price_each}, #{@quantity});")
    true
  end

  def update
    return false unless valid?
    
    client = create_db_client
    client.query("update itemOrders set quantity = '#{@quantity}', price_each = '#{@price_each}' where order_id = #{@order_id} and item_id = #{@item};")
    true
  end

  def valid?
    return false if @item.nil?
    true
  end

  def self.convert_query_to_list(raw_data)
    item_orders = Array.new
    raw_data.each do |data|
      item = Item.new(
        :id => data["item_id"], 
        :name => data["name"]
      )
      item_order = ItemOrder.new(
        :order_id => data["order_id"],
        :item => item,
        :price_each => data["price_each"],
        :quantity => data["quantity"]
      )
      item_orders.push(item_order)
    end
    item_orders
  end

end
