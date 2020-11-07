require './models/item.rb'
require './models/category.rb'

class ItemController

  def index
    items = Item.get_all
    renderer = ERB.new(File.read("./views/item/index.erb"))
    renderer.result(binding)
  end

  def show(id)
    item = Item.get_one(id)
    renderer = ERB.new(File.read("./views/item/show.erb"))
    renderer.result(binding)
  end

  def new_item
    categories = Category.get_all
    renderer = ERB.new(File.read("./views/item/new.erb"))
    renderer.result(binding)
  end

  def delete(id)
    items = Item.delete(id)
    
    index
  end

  def create(params)
    
    item = Item.new(params["item_name"], params["item_price"], params)
    item.save

    index
  end

  def edit(id)
    item = Item.get_one(id)
    renderer = ERB.new(File.read("./views/item/edit.erb"))
    renderer.result(binding)
  end

  def update(params)
    item = Item.new(params["item_name"], params["item_price"], params["id"])
    item.update

    index
  end

end
