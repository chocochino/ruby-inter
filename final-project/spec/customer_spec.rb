require './db/mysql_connector.rb'
require './models/customer.rb'

describe Customer do
  let(:test_name) { 'John Doe' }
  let(:test_phone) { '+62856565656' }
  let(:test_id) { 1 }
  let(:valid_customer) { Customer.new(:name => test_name, :phone => test_phone) }

  before(:all) do 
    @client = create_db_client
    @client.query('SET foreign_key_checks = 0;')
  end

  before(:each) do
    @client.query('TRUNCATE TABLE customers;')
  end

  describe '#valid' do
    context 'when initialized with valid input' do
      it 'returns true' do
        customer = valid_customer
        expect(customer.valid?).to eq(true)
      end
    end
    
    context 'when initialized without name' do
      it 'returns false' do
        customer = Customer.new(:phone => test_phone)
        expect(customer.valid?).to eq(false)
      end
    end

    context 'when initialized without phone' do
      it 'returns false' do
        customer = Customer.new(:name => test_name)
        expect(customer.valid?).to eq(false)
      end
    end
  end

  describe '#save' do
    context 'when initialized with valid input' do
      it 'saves input to database' do
        before_count = @client.query("select * from customers;").size
        customer = Customer.new(
                    :name => test_name, 
                    :phone => test_phone
                  )
        customer.save
        after_count = @client.query("select * from customers;").size
        expect(after_count).not_to eq(before_count)
      end
    end

    context 'when initialized without name' do
      it 'does not save input to database' do
        before_count = @client.query("select * from customers;").size
        customer = Customer.new(
                    :phone => test_phone
                  )
        customer.save
        after_count = @client.query("select * from customers;").size
        expect(after_count).to eq(before_count)
      end
    end

    context 'when initialized without phone' do
      it 'does not save input to database' do
        before_count = @client.query("select * from customers;").size
        customer = Customer.new(
                    :name => test_name
                  )
        customer.save
        after_count = @client.query("select * from customers;").size
        expect(after_count).to eq(before_count)
      end
    end
  end

  describe '#get_all' do
    before do
      3.times { valid_customer.save } 
    end

    it 'gets all customers from database' do
      total = @client.query("select * from customers;").size
      customers = Customer.get_all
      expect(customers.size).to eq(total)
    end
  end

  describe '#get_one' do
    before do
      valid_customer.save
    end

    it 'gets one customer from database' do
      query_result = Customer.get_one(test_id)
      expect(query_result.phone).to eq(valid_customer.phone)
    end
  end

  describe '#update' do
    let(:changed_name) { "Budiawan" }

    before do
      valid_customer.save
    end

    it 'updates a customer into database' do
      old_customer = Customer.get_one(test_id)
      to_update = Customer.new(
        :id => test_id,
        :name => changed_name,
        :phone => test_phone
      )
      to_update.update
      new_customer = Customer.get_one(test_id)
      
      expect(new_customer.name).to eq(changed_name)
    end
  end

  describe '#delete' do
    before do
      valid_customer.save
    end

    it 'deletes a customer from database' do
      before_count = @client.query("select * from customers;").size
      Customer.delete(test_id)
      after_count = @client.query("select * from customers;").size
      expect(after_count).not_to eq(before_count)  
    end
  end

  after(:all) do
    @client.query('SET foreign_key_checks = 1;')
  end
  
end
