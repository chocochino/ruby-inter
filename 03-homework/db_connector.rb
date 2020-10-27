require 'mysql2'
require "./models/item"
require "./models/category"

def create_db_client
  client = Mysql2::Client.new(
    :host => '127.0.0.1',
    :username => 'admin',
    :password => 'pass',
    :database => 'food_oms_db'
  )
  client
end

def get_all_items
  client = create_db_client
  items = client.query("select * from items")
end

def get_item_detail(id)
  client = create_db_client
  data = client.query("select i.id, i.name, i.price, c.name as category_name, c.id as category_id from items i left join item_categories ic on i.id = ic.item_id left join categories c on c.id = ic.category_id where i.id = #{id}")
  
  item = nil
  data.each do |data|
    category = Category.new(data["category_name"], data["category_id"])
    item = Item.new(data["name"], data["price"], data["id"], category)
  end

  item
end

def create_new_item(name, price)
  client = create_db_client
  client.query("insert into items (name, price) values('#{name}', '#{price}')")
end

def edit_item(id, name, price)
  client = create_db_client
  client.query("update items set name = '#{name}', price = '#{price}' where id = #{id}")
end

def delete_item(id)
  client = create_db_client
  client.query("delete from items where id = #{id}")
end

def get_all_categories
  client = create_db_client
  categories = client.query("select * from categories")
end

def get_all_items_and_categories
  client = create_db_client
  raw_data = client.query("select i.id, i.name, i.price, c.name as category_name, c.id as category_id from items i left join item_categories ic on i.id = ic.item_id left join categories c on c.id = ic.category_id;")
  
  items = Array.new
  raw_data.each do |data|
    category = Category.new(data["category_name"], data["category_id"])
    item = Item.new(data["name"], data["price"], data["id"], category)
    items.push(item)
  end
  
  items
end

def get_items_below_price(min_price)
  client = create_db_client
  items = client.query("select * from items where price < #{min_price}")
end
