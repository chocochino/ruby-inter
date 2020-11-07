require 'mysql2'

def create_db_client
  client = Mysql2::Client.new(
    :host => "localhost",
    :username => "admin",
    :password => ENV["DB_PASSWORD"],
    :database => "food_oms_db"
    # :database => "food_testing"
  )

  client
end
