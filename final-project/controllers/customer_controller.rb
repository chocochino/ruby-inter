require './models/customer.rb'

class CustomerController

  def index
    customers = Customer.get_all
    renderer = ERB.new(File.read('./views/customer/index.erb'))
    renderer.result(binding)
  end

  def show(id)
    customer = Customer.get_one(id)
    renderer = ERB.new(File.read('./views/customer/show.erb'))
    renderer.result(binding)
  end
  
  def new_entry
    renderer = ERB.new(File.read('./views/customer/new.erb'))
    renderer.result(binding)
  end

  def create(params)
    customer = Customer.new(
      :name => params["name"],
      :phone => params["phone"]
    )
    
    customer.save ? index : "New customer data unsaved"
  end

end
