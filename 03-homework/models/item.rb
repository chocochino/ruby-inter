class Item

  attr_accessor :name, :price, :id, :category

  def initialize(name, price, id, category = nil)
    @name = name
    @price = price
    @id = id
    @category = category
  end

  def to_s
    puts("Id: #{id}\nName: #{name}\nPrice: #{price}\nCategory: #{category.name}")
  end
end
