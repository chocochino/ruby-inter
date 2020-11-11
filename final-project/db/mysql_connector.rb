require 'mysql2'

def create_db_client
  client = Mysql2::Client.new(
    :host => "localhost",
    :username => ENV["DB_USERNAME"],
    :password => ENV["DB_PASSWORD"],
    # :database => "rubyinter"
    :database => "rubyinter_test"
  )

  client
end
