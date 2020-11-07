require './db/mysql_connector.rb'
require './models/item.rb'

class Category
  attr_accessor :id, :name, :items

  def initialize(name, id = nil, items = nil)
    @id = id
    @name = (name.nil? ? 'None' : name)
    @items = []
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select * from categories order by id")
    categories = self.convert_data_to_list(raw_data)
  end
  
  def self.get_one(id)
    client = create_db_client
    raw_data = client.query("select * from categories where id = #{id}")
    category = self.convert_data_to_object(raw_data)

    raw_data = client.query("select * from items where category_id = #{id}")
    category.items = Item.convert_data_to_list(raw_data)

    return false if category.nil?
    category
  end
  
  def self.delete(id)
    client = create_db_client
    client.query("delete from categories where id = #{id}")
  end

  def save
    client = create_db_client
    client.query("insert into categories (name) values('#{@name}')")
  end

  def update
    client = create_db_client
    client.query("update categories set name = '#{@name}' where id = #{@id}")
  end

  def valid?
    return false if @name.nil?
    true
  end

  def self.convert_data_to_list(raw_data)
    categories = Array.new

    raw_data.each do |data|
      category = Category.new(data["name"], data["id"])
      categories.push(category)
    end

    categories
  end
  
  def self.convert_data_to_object(raw_data)
    category = nil

    raw_data.each do |data|
      category = Category.new(data["name"], data["id"])
    end

    category
  end

end
