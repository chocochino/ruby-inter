# require './db/mysql_connector.rb'
require './models/customer.rb'

describe Customer do
  # before(:each) do
  #   @client = create_db_client
  #   @client.query('TRUNCATE TABLE customers')
  # end

  describe '#valid' do
    context 'when initialized with valid input' do
      it 'should return true' do
        customer = Customer.new(
                    :name => "John Doe", 
                    :phone => "+62856565656"
                  )
        expect(customer.valid?).to eq(true)
      end
    end
    
    context 'when initialized without name' do
      it 'should return false' do
        customer = Customer.new(:phone => "+62856565656")
        expect(customer.valid?).to eq(false)
      end
    end

    context 'when initialized without phone' do
      it 'should return false' do
        customer = Customer.new(:name => "John Doe")
        expect(customer.valid?).to eq(false)
      end
    end
  end
  
end
