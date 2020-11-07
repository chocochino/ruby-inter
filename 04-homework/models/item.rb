require './db/mysql_connector.rb'
require './models/category.rb'

class Item
  attr_accessor :id, :name, :price, :category

  def initialize(name, price, id = nil, category = nil)
    @id = id
    @name = name
    @price = price
    @category = category
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select * from items order by id")
    items = self.convert_data_to_list(raw_data)
  end
  
  def self.get_one(id)
    client = create_db_client
    raw_data = client.query("select i.id, i.name, i.price, c.id as category_id, c.name as category_name from items i left join categories c on i.category_id = c.id where i.id = #{id}")
    item = self.convert_data_to_object(raw_data)
  end
  
  def self.delete(id)
    client = create_db_client
    client.query("delete from items where id = #{id}")
  end

  def save
    client = create_db_client
    client.query("insert into items (name, price) values('#{@name}', '#{@price}')")
  end

  def update
    client = create_db_client
    client.query("update items set name = '#{@name}', price = '#{@price}' where id = #{@id}")
  end

  def self.convert_data_to_list(raw_data)
    items = Array.new

    raw_data.each do |data|
      item = Item.new(data["name"], data["price"], data["id"])
      items.push(item)
    end

    items
  end
  
  def self.convert_data_to_object(raw_data)
    item = nil

    raw_data.each do |data|
      category = Category.new(data['category_name'], data['category_id'])
      item = Item.new(data["name"], data["price"], data["id"], category)
    end

    item
  end

  private

  def valid?
    return false if @name.nil?
    return false if @price.nil?
    true
  end

end
