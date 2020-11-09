require './db/mysql_connector.rb'

class Customer

  attr_accessor :id, :name, :phone

  def initialize(hash)
    @id = hash[:id]
    @name = hash[:name]
    @phone = hash[:phone]
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
  end

  def save
    return false unless valid?
    
    client = create_db_client
    client.query("insert into customers(name, phone) values ('#{@name}', '#{@phone}');")
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
    raw_data.each do |data|
      customer = Customer.new(
        :id => data["customer_id"], 
        :name => data["name"], 
        :phone => data["phone"])
    end
    customer
  end

end
