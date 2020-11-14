require './db/mysql_connector.rb'
require './models/order.rb'
require 'date'

describe Order do
  let(:test_date) { Date.today }
  let(:complete) { 1 }
  let(:test_id) { 1 }
  let(:customer) { Customer.new(:name => 'John Doe', :phone => '0987654321') }
  let(:empty_order) { Order.new(:order_date => test_date) }
  let(:full_order) { Order.new(:order_date => test_date, :is_complete => complete, :customer => test_id )}

  before(:all) do 
    @client = create_db_client
    @client.query('SET foreign_key_checks = 0;')
  end

  before(:each) do
    @client.query('TRUNCATE TABLE orders;')
    @client.query('TRUNCATE TABLE customers;')
  end

  describe '#valid' do
    context 'when initialized with valid parameters' do
      it 'returns true' do
        order = empty_order
        expect(order.valid?).to eq(true)
      end
    end

    context 'when initialized with completed' do
      it 'returns true with customer' do
        order = full_order
        expect(order.valid?).to eq(true)
      end

      it 'returns false without customer' do
        order = Order.new(
          :order_date => test_date,
          :is_complete => complete
        )
        expect(order.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    it 'saves input to database' do
      before_count = @client.query("select * from orders;").size
      empty_order.save
      after_count = @client.query("select * from orders;").size
      expect(after_count).not_to eq(before_count)
    end
  end

  describe '#get_all' do
    before do
      customer.save
      3.times { full_order.save } 
    end

    it 'gets all orders from database' do
      total = @client.query("select * from orders;").size
      orders = Order.get_all
      expect(orders.size).to eq(total)
    end
  end

  describe '#get_one' do
    before do
      customer.save
      full_order.save
    end

    it 'gets one order from database' do
      query_result = Order.get_one(test_id)
      expect(query_result.order_date).to eq(empty_order.order_date)
    end
  end

  describe '#get_empty_order' do
    before do
      empty_order.save
    end

    it 'gets one empty order from database' do
      query_result = Order.get_empty_order
      expect(query_result.is_complete).not_to eq(complete)
    end
  end

  describe '#update' do
    before do
      empty_order.save
      customer.save
    end

    it 'updates a order into database' do
      old_order = Order.get_empty_order
      to_update = Order.new(
        :id => old_order.id,
        :order_date => old_order.order_date,
        :is_complete => complete,
        :customer => test_id
      )
      to_update.update
      new_order = Order.get_one(old_order.id)
      expect(new_order.customer.name).to eq(customer.name)
    end
  end

  describe '#delete' do
    before do
      empty_order.save
    end

    it 'deletes a order from database' do
      before_count = @client.query("select * from orders;").size
      Order.delete(test_id)
      after_count = @client.query("select * from orders;").size
      expect(after_count).not_to eq(before_count)  
    end
  end

  after(:all) do
    @client.query('SET foreign_key_checks = 1;')
  end
  
end
