require './models/item.rb'

class ItemController

  def index
    items = Item.get_all
    renderer = ERB.new(File.read('./views/item/index.erb'))
    renderer.result(binding)
  end

  def show(id)
    item = Item.get_one(id)
    unless item then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/item/show.erb'))
    end
    renderer.result(binding)
  end
  
  def new_entry
    renderer = ERB.new(File.read('./views/item/new.erb'))
    renderer.result(binding)
  end

  def edit(id)
    item = Item.get_one(id)
    unless item then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/item/edit.erb'))
    end
    renderer.result(binding)
  end  

  def create(params)
    item = Item.new(
      :name => params["name"],
      :price => params["price"]
    )
    
    if item.save then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def update(params)
    item = Item.new(
      :id => params["id"],
      :name => params["name"],
      :price => params["price"]
    )
    
    if item.update then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def delete(id)
    Item.delete(id)
    index
  end

end
