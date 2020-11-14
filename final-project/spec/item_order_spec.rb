require './db/mysql_connector.rb'
require './models/item.rb'
require './models/order.rb'
require './models/item_order.rb'
require 'date'

describe ItemOrder do
  let(:test_item) { Item.new(:name => 'Nasi Goreng', :price => 10000) }
  let(:test_order) { Order.new(:order_date => Date.today) }
  let(:test_id) { 1 }
  let(:initial_item_order) { ItemOrder.new(:item => test_id) }
  let(:invalid_item_order) { ItemOrder.new(:quantity => 100) }

  before(:all) do 
    @client = create_db_client
    @client.query('SET foreign_key_checks = 0;')
  end

  before(:each) do
    @client.query('TRUNCATE TABLE itemOrders;')
    @client.query('TRUNCATE TABLE items;')
    @client.query('TRUNCATE TABLE orders;')
    test_order.save
    test_item.save
  end

  describe '#valid' do
    context 'when initialized with valid input' do
      it 'returns true' do
        item_order = initial_item_order
        expect(item_order.valid?).to eq(true)
      end
    end
    
    context 'when initialized without item' do
      it 'returns false' do
        item = invalid_item_order
        expect(item.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid input' do
      it 'saves input to database' do
        before_count = @client.query("select * from itemOrders;").size
        initial_item_order.save
        after_count = @client.query("select * from itemOrders;").size
        expect(after_count).not_to eq(before_count)
      end
    end

    context 'when initialized without item' do
      it 'does not save input to database' do
        before_count = @client.query("select * from itemOrders;").size
        invalid_item_order.save
        after_count = @client.query("select * from itemOrders;").size
        expect(after_count).to eq(before_count)
      end
    end
  end

  describe '#get_one' do
    before do
      3.times do |i|
        item_order = ItemOrder.new(:item => i+1)
        item_order.save
        test_item.save
      end 
    end

    it 'gets all items from database' do
      total = @client.query("select * from itemOrders where order_id = #{test_id};").size
      item_orders = ItemOrder.get_one(test_id)
      expect(item_orders.size).to eq(total)
    end
  end

  describe '#update' do
    let(:new_quantity) { 2 }

    before do
      initial_item_order.save
    end

    it 'updates a item into database' do
      old_item = ItemOrder.get_one(test_id).first
      to_update = ItemOrder.new(
        :order_id => old_item.order_id,
        :item => old_item.item.id,
        :quantity => new_quantity
      )
      to_update.update
      new_item = ItemOrder.get_one(old_item.order_id).first
      
      expect(new_item.quantity).to eq(new_quantity)
    end
  end

  describe '#delete' do
    before do
      initial_item_order.save
    end

    it 'deletes a item from database' do
      before_count = @client.query("select * from itemOrders where order_id = #{test_id} and item_id = #{test_id};").size
      ItemOrder.delete(test_id, test_id)
      after_count = @client.query("select * from itemOrders where order_id = #{test_id} and item_id = #{test_id};").size
      expect(after_count).not_to eq(before_count)  
    end
  end

  describe '#clear' do
    before do
      3.times do |i|
        item_order = ItemOrder.new(:item => i+1)
        item_order.save
        test_item.save
      end 
    end

    it 'deletes all itemOrders from one order_id' do
      before_count = @client.query("select * from itemOrders where order_id = #{test_id};").size
      ItemOrder.clear(test_id)
      after_count = @client.query("select * from itemOrders where order_id = #{test_id};").size
      expect(after_count).not_to eq(before_count)
    end
  end

  after(:all) do
    @client.query('SET foreign_key_checks = 1;')
  end
  
end
