require './db/mysql_connector.rb'
require './models/customer.rb'
require './models/item_order.rb'

class Order

  attr_accessor :id, :customer, :order_date, :is_complete, :item_orders

  def initialize(hash)
    @id = hash[:id]
    @customer = hash[:customer]
    @order_date = hash[:order_date]
    @is_complete = hash[:is_complete]
    @is_complete = 0 if hash[:is_complete].nil?
    @item_orders = Array.new
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select o.order_id, o.customer_id, o.order_date, c.name from orders o inner join customers c using(customer_id) order by o.order_id desc;")
    orders = self.convert_query_to_list(raw_data)
  end

  def self.get_empty_order
    client = create_db_client
    raw_data = client.query("select * from orders where is_complete = false order by order_id desc limit 1")
    order = self.convert_query_to_object(raw_data)
  end

  def self.get_one(id)
    client = create_db_client
    raw_data = client.query(
      "select o.order_id, o.customer_id, o.order_date, c.name, c.phone from orders o inner join customers c using(customer_id) where o.order_id = #{id};")
    order = self.convert_query_to_object(raw_data)
    order.item_orders = ItemOrder.get_one(id)
    order
  end

  def self.delete(id)
    client = create_db_client
    client.query("delete from orders where order_id = #{id}")
  end

  def save
    return false unless valid?
    
    client = create_db_client
    if customer.nil? then
      client.query("insert into orders(order_date, is_complete) values ('#{@order_date}', #{@is_complete});")
    else
      client.query("insert into orders(order_date, is_complete, customer_id) values ('#{@order_date}', #{@is_complete}, #{customer});")
    end
    true
  end

  def update
    return false unless valid?
    
    client = create_db_client
    client.query("update orders set order_date = '#{@order_date}', is_complete = #{@is_complete} where order_id = #{@id};")
    unless @customer.nil? then
      client.query("update orders set customer_id = #{@customer} where order_id = #{@id};")
    end
    true
  end

  def valid?
    return false if @order_date.nil?
    return false if @is_complete == 1 && @customer.nil?
    true
  end

  def self.convert_query_to_list(raw_data)
    orders = Array.new
    raw_data.each do |data|
      customer = Customer.new(
        :id => data["customer_id"],
        :name => data["name"]
      )
      order = Order.new(
        :id => data["order_id"], 
        :order_date => data["order_date"],
        :customer => customer
      )
      orders.push(order)
    end
    orders
  end

  def self.convert_query_to_object(raw_data)
    order = nil
    raw_data.each do |data|
      customer = Customer.new(
        :id => data["customer_id"],
        :name => data["name"],
        :phone => data["phone"]
      )
      order = Order.new(
        :id => data["order_id"], 
        :order_date => data["order_date"], 
        :is_complete => data["is_complete"],
        :customer => customer
      )
    end
    order
  end
end
