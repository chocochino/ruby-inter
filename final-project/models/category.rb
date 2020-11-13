require './db/mysql_connector.rb'

class Category

  attr_accessor :id, :name, :items

  def initialize(hash)
    @id = hash[:id]
    @name = hash[:name]
    @items = Array.new
  end

  def self.get_all
    client = create_db_client
    raw_data = client.query("select * from categories;")
    categories = self.convert_query_to_list(raw_data)
  end

  def self.get_one(id)
    client = create_db_client
    raw_data = client.query(
      "select * from categories where category_id = #{id};")
    category = self.convert_query_to_object(raw_data)
    
    raw_data = client.query("select io.item_id, i.name from itemCategories io inner join items i using(item_id) where io.category_id = #{id};")
    category.items = Item.convert_query_to_list(raw_data)
    category
  end

  def self.delete(id)
    client = create_db_client
    client.query("delete from categories where category_id = #{id}")
  end

  def save
    return false unless valid?
    
    client = create_db_client
    client.query("insert into categories(name) values ('#{@name}');")
    true
  end

  def update
    return false unless valid?
    
    client = create_db_client
    client.query("update categories set name = '#{@name}' where category_id = #{@id};")
    true
  end

  def valid?
    return false if @name.nil?
    true
  end

  def self.convert_query_to_list(raw_data)
    categories = Array.new
    raw_data.each do |data|
      category = Category.new(
        :id => data["category_id"], 
        :name => data["name"]
      )
      categories.push(category)
    end
    categories
  end

  def self.convert_query_to_object(raw_data)
    category = nil
    raw_data.each do |data|
      category = Category.new(
        :id => data["category_id"], 
        :name => data["name"])
    end
    category
  end

end
