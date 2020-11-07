require './martabak'

describe Martabak do
  it "is delicious" do
    martabak = Martabak.new("cheese")
    taste = martabak.taste

    expect(taste).to eq("cheese martabak is delicious")
  end
end
