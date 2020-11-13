require './models/category.rb'

class CategoryController

  def index
    categories = Category.get_all
    renderer = ERB.new(File.read('./views/category/index.erb'))
    renderer.result(binding)
  end

  def show(id)
    category = Category.get_one(id)
    unless category then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/category/show.erb'))
    end
    renderer.result(binding)
  end
  
  def new_entry
    renderer = ERB.new(File.read('./views/category/new.erb'))
    renderer.result(binding)
  end

  def edit(id)
    category = Category.get_one(id)
    unless category then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/category/edit.erb'))
    end
    renderer.result(binding)
  end  

  def create(params)
    category = Category.new(
      :name => params["name"]
    )
    
    if category.save then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def update(params)
    category = Category.new(
      :id => params["id"],
      :name => params["name"]
    )
    
    if category.update then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def delete(id)
    Category.delete(id)
    index
  end

end
