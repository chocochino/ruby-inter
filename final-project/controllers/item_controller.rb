require './models/item.rb'
require './models/category.rb'

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
    categories = Category.get_all
    renderer = ERB.new(File.read('./views/item/new.erb'))
    renderer.result(binding)
  end

  def edit(id)
    item = Item.get_one(id)
    unless item then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      categories = Category.get_all
      category_checked = Array.new
      item.categories.each {|category| category_checked.append(category.id) }
      renderer = ERB.new(File.read('./views/item/edit.erb'))
    end
    renderer.result(binding)
  end  

  def create(params)
    item = Item.new(
      :name => params["name"],
      :price => params["price"],
    )
    item.categories = assign_categories(params.keys)
    
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
      :price => params["price"],
    )
    item.categories = assign_categories(params.keys)
    
    if item.update then
      show(params["id"])
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def delete(id)
    Item.delete(id)
    index
  end
  
  def assign_categories(keys)
    categories = Array.new
    keys.each do |key|
      if key.include?('category') then
        categories.append(key.partition('_').last)
      end
    end
    categories
  end

end
