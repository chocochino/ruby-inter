require './db/mysql_connector.rb'
require './models/item.rb'

describe Item do
  let(:test_name) { 'Nasi Goreng' }
  let(:test_price) { 50000 }
  let(:test_id) { 1 }
  let(:valid_item) { Item.new(:name => test_name, :price => test_price) }

  before(:all) do 
    @client = create_db_client
    @client.query('SET foreign_key_checks = 0;')
  end

  before(:each) do
    @client.query('TRUNCATE TABLE items;')
  end

  describe '#valid' do
    context 'when initialized with valid input' do
      it 'returns true' do
        item = valid_item
        expect(item.valid?).to eq(true)
      end
    end
    
    context 'when initialized without name' do
      it 'returns false' do
        item = Item.new(:price => test_price)
        expect(item.valid?).to eq(false)
      end
    end

    context 'when initialized without price' do
      it 'returns false' do
        item = Item.new(:name => test_name)
        expect(item.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid input' do
      it 'saves input to database' do
        before_count = @client.query("select * from items;").size
        item = Item.new(
                    :name => test_name, 
                    :price => test_price
                  )
        item.save
        after_count = @client.query("select * from items;").size
        expect(after_count).not_to eq(before_count)
      end
    end

    context 'when initialized without name' do
      it 'does not save input to database' do
        before_count = @client.query("select * from items;").size
        item = Item.new(
                    :price => test_price
                  )
        item.save
        after_count = @client.query("select * from items;").size
        expect(after_count).to eq(before_count)
      end
    end

    context 'when initialized without price' do
      it 'does not save input to database' do
        before_count = @client.query("select * from items;").size
        item = Item.new(
                    :name => test_name
                  )
        item.save
        after_count = @client.query("select * from items;").size
        expect(after_count).to eq(before_count)
      end
    end
  end

  describe '#get_all' do
    before do
      3.times { valid_item.save } 
    end

    it 'gets all items from database' do
      total = @client.query("select * from items;").size
      items = Item.get_all
      expect(items.size).to eq(total)
    end
  end

  describe '#get_one' do
    before do
      valid_item.save
    end

    it 'gets one item from database' do
      query_result = Item.get_one(test_id)
      expect(query_result.price).to eq(valid_item.price)
    end
  end

  describe '#update' do
    let(:changed_name) { "Bakmi Ayam" }

    before do
      valid_item.save
    end

    it 'updates a item into database' do
      old_item = Item.get_one(test_id)
      to_update = Item.new(
        :id => test_id,
        :name => changed_name,
        :price => test_price
      )
      to_update.update
      new_item = Item.get_one(test_id)
      
      expect(new_item.name).to eq(changed_name)
    end
  end

  describe '#delete' do
    before do
      valid_item.save
    end

    it 'deletes a item from database' do
      before_count = @client.query("select * from items;").size
      Item.delete(test_id)
      after_count = @client.query("select * from items;").size
      expect(after_count).not_to eq(before_count)  
    end
  end

  after(:all) do
    @client.query('SET foreign_key_checks = 1;')
  end
  
end
