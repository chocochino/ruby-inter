require './models/customer.rb'

class CustomerController

  def index
    customers = Customer.get_all
    renderer = ERB.new(File.read('./views/customer/index.erb'))
    renderer.result(binding)
  end

  def show(id)
    customer = Customer.get_one(id)
    unless customer then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/customer/show.erb'))
    end
    renderer.result(binding)
  end
  
  def new_entry
    renderer = ERB.new(File.read('./views/customer/new.erb'))
    renderer.result(binding)
  end

  def edit(id)
    customer = Customer.get_one(id)
    unless customer then
      renderer = ERB.new(File.read('./views/error.erb'))  
    else
      renderer = ERB.new(File.read('./views/customer/edit.erb'))
    end
    renderer.result(binding)
  end  

  def create(params)
    customer = Customer.new(
      :name => params["name"],
      :phone => params["phone"]
    )
    
    if customer.save then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def update(params)
    customer = Customer.new(
      :id => params["id"],
      :name => params["name"],
      :phone => params["phone"]
    )
    
    if customer.update then
      index
    else 
      renderer = ERB.new(File.read('./views/error.erb'))
      renderer.result(binding)
    end
  end

  def delete(id)
    Customer.delete(id)
    index
  end

end
