require './db/mysql_connector.rb'
require './models/category.rb'

class Item

  attr_accessor :id, :name, :price, :categories

  def initialize(hash)
    @id = hash[:id]
    @name = hash[:name]
    @price = hash[:price]
    @categories = Array.new
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select * from items;")
    items = self.convert_query_to_list(raw_data)
  end

  def self.get_one(id)
    client = create_db_client
    raw_data = client.query(
      "select * from items where item_id = #{id};")
    item = self.convert_query_to_object(raw_data)
    
    raw_data = client.query("select io.category_id, c.name from itemCategories io inner join categories c using(category_id) where io.item_id = #{id};")
    item.categories = Category.convert_query_to_list(raw_data)
    item
  end

  def self.delete(id)
    client = create_db_client
    client.query("delete from items where item_id = #{id}")
  end

  def save
    return false unless valid?
    
    client = create_db_client
    client.query("insert into items(name, price) values ('#{@name}', '#{@price}');")

    raw_data = client.query("select item_id from items where name = '#{@name}';").each
    raw_data.each { |data| @id = data["item_id"] }

    if @categories.any? then
      @categories.each do |category|
        client.query("insert into itemCategories(item_id, category_id) values (#{@id}, #{category});")
      end
    end
    true
  end

  def update
    return false unless valid?
    
    client = create_db_client
    client.query("update items set name = '#{@name}', price = '#{@price}' where item_id = #{@id};")

    if @categories.any? then
      client.query("delete from itemCategories where item_id = #{@id}")
      @categories.each do |category|
        client.query("insert into itemCategories(item_id, category_id) values (#{@id}, #{category});")
      end
    end

    true
  end

  def valid?
    return false if @name.nil?
    return false if @price.nil?
    true
  end

  def self.convert_query_to_list(raw_data)
    items = Array.new
    raw_data.each do |data|
      item = Item.new(
        :id => data["item_id"], 
        :name => data["name"], 
        :price => data["price"]
      )
      items.push(item)
    end
    items
  end

  def self.convert_query_to_object(raw_data)
    item = nil
    raw_data.each do |data|
      item = Item.new(
        :id => data["item_id"], 
        :name => data["name"], 
        :price => data["price"])
    end
    item
  end

end
