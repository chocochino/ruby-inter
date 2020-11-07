require './models/category.rb'

class CategoryController

  def index
    categories = Category.get_all
    renderer = ERB.new(File.read("./views/category/index.erb"))
    renderer.result(binding)
  end

  def show(id)
    category = Category.get_one(id)
    if category then
      renderer = ERB.new(File.read("./views/category/show.erb"))
    else
      renderer = ERB.new(File.read("./views/error.erb"))
    end
    renderer.result(binding)
  end

  def new_category
    renderer = ERB.new(File.read("./views/category/new.erb"))
    renderer.result(binding)
  end

  def delete(id)
    categories = Category.delete(id)
    
    index
  end

  def create(params)
    category = Category.new(params["category_name"])
    category.save

    index
  end

  def edit(id)
    category = Category.get_one(id)
    renderer = ERB.new(File.read("./views/category/edit.erb"))
    renderer.result(binding)
  end

  def update(params)
    category = Category.new(params["category_name"], params["id"])
    category.update

    index
  end

end
