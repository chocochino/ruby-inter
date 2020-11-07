class Martabak

  attr_reader :topping

  def initialize(topping)
    @topping = topping
  end

  def taste
    "#{@topping} martabak is delicious"
  end

end
