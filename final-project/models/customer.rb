require './db/mysql_connector.rb'
require './models/order.rb'

class Customer

  attr_accessor :id, :name, :phone, :orders

  def initialize(hash)
    @id = hash[:id]
    @name = hash[:name]
    @phone = hash[:phone]
    @orders = []
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select * from customers;")
    customers = self.convert_query_to_list(raw_data)
  end

  def self.get_one(id)
    client = create_db_client
    raw_data = client.query(
      "select * from customers where customer_id = #{id};")
    customer = self.convert_query_to_object(raw_data)
    raw_data = client.query(
      "select o.order_id, o.order_date, c.customer_id, c.name from orders o inner join customers c using(customer_id) where o.customer_id = #{id};")
    customer.orders = Order.convert_query_to_list(raw_data)
    customer
  end

  def self.delete(id)
    client = create_db_client
    client.query("delete from customers where customer_id = #{id}")
  end

  def save
    return false unless valid?
    
    client = create_db_client
    client.query("insert into customers(name, phone) values ('#{@name}', '#{@phone}');")
    true
  end

  def update
    return false unless valid?
    
    client = create_db_client
    client.query("update customers set name = '#{@name}', phone = '#{@phone}' where customer_id = #{@id};")
    true
  end

  def valid?
    return false if @name.nil?
    return false if @phone.nil?
    true
  end

  def self.convert_query_to_list(raw_data)
    customers = Array.new
    raw_data.each do |data|
      customer = Customer.new(
        :id => data["customer_id"], 
        :name => data["name"], 
        :phone => data["phone"]
      )
      customers.push(customer)
    end
    customers
  end

  def self.convert_query_to_object(raw_data)
    customer = nil
    orders = Array.new
    raw_data.each do |data|
      customer = Customer.new(
        :id => data["customer_id"], 
        :name => data["name"], 
        :phone => data["phone"])
    end
    customer
  end

end
