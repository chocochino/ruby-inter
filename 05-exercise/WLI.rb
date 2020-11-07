class WLI

  attr_accessor :names

  def initialize
    @names = Array.new
  end

  def likes
    size = @names.size
    if size == 0 then
      return "No one likes this"
    elsif size == 1 then
      return "#{@names[0]} likes this"
    elsif size == 2 then
      return "#{@names[0]} and #{@names[1]} like this" 
    elsif size == 3
      return "#{@names[0]}, #{@names[1]} and #{@names[2]} like this"
    else
      return "#{@names[0]}, #{@names[1]} and #{size - 2} others like this" 
    end
  end

end
