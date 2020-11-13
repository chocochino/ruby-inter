require './db/mysql_connector.rb'
require './models/category.rb'

describe Category do
  let(:test_name) { 'Dessert' }
  let(:test_id) { 1 }
  let(:valid_category) { Category.new(:name => test_name) }

  before(:all) do 
    @client = create_db_client
    @client.query('SET foreign_key_checks = 0;')
  end

  before(:each) do
    @client.query('TRUNCATE TABLE categories;')
  end

  describe '#valid' do
    context 'when initialized with valid input' do
      it 'returns true' do
        category = valid_category
        expect(category.valid?).to eq(true)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid input' do
      it 'saves input to database' do
        before_count = @client.query("select * from categories;").size
        category = Category.new(
                    :name => test_name
                  )
        category.save
        after_count = @client.query("select * from categories;").size
        expect(after_count).not_to eq(before_count)
      end
    end
  end

  describe '#get_all' do
    before do
      3.times { valid_category.save } 
    end

    it 'gets all categories from database' do
      total = @client.query("select * from categories;").size
      categories = Category.get_all
      expect(categories.size).to eq(total)
    end
  end

  describe '#get_one' do
    before do
      valid_category.save
    end

    it 'gets one category from database' do
      query_result = Category.get_one(test_id)
      expect(query_result.name).to eq(valid_category.name)
    end
  end

  describe '#update' do
    let(:changed_name) { "Coffee" }

    before do
      valid_category.save
    end

    it 'updates a category into database' do
      old_category = Category.get_one(test_id)
      to_update = Category.new(
        :id => test_id,
        :name => changed_name
      )
      to_update.update
      new_category = Category.get_one(test_id)
      
      expect(new_category.name).to eq(changed_name)
    end
  end

  describe '#delete' do
    before do
      valid_category.save
    end

    it 'deletes a category from database' do
      before_count = @client.query("select * from categories;").size
      Category.delete(test_id)
      after_count = @client.query("select * from categories;").size
      expect(after_count).not_to eq(before_count)  
    end
  end

  after(:all) do
    @client.query('SET foreign_key_checks = 1;')
  end
  
end
