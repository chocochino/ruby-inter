require './db/mysql_connector.rb'
require './models/category.rb'

describe Category do
  before(:each) do
    @client = create_db_client
    @client.query("TRUNCATE TABLE categories")
  end

  describe '#valid?' do
    context 'when initialized with valid input' do
      it 'should return true' do
        category = Category.new("Coffee")
        expect(category.valid?).to eq(true)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid input' do
      it 'should save to database' do
        before_save = @client.query("select count(name) from categories")

        category = Category.new("Tea")
        category.save
        
        after_save = @client.query("select count(name) from categories")  
        
        expect(after_save).not_to eq(before_save)
      end
    end
  end

  describe '#delete' do
    before do
      @index = 4
      category = Category.new("Coffee", @index)
      category.save  
    end

    it 'should delete data' do
        before_save = nil
        data = @client.query("select count(id) from categories")
        data.each do |da|
          before_save = da["count(id)"]
        end

        Category.delete(@index)
        
        after_save = nil
        data = @client.query("select count(id) from categories")
        data.each do |da|
          after_save = da["count(id)"]
        end

        expect(after_save).to eq(1)
    end
  end

  # describe '#update' do
  #   before do
  #     @index = 4
  #     category = Category.new("Tea", @index)
  #     category.save  
  #   end

  #   it 'should update data' do
  #       before_save = @client.query("select name from categories where id = #{@index}")

  #       category = Category.new("Coffee", @index)
  #       category.update
        
  #       after_save = @client.query("select name from categories where id = #{@index}")
        
  #       expect(after_save).to eq("Coffee")
  #   end
  # end

end
