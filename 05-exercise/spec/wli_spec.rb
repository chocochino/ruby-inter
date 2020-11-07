require './WLI'

describe WLI do
  describe '#likes' do
    context 'when 2 people like it' do
      it "should show all names" do
        wli = WLI.new
        wli.names = ["Jacob", "Alex"]
        likes = wli.likes

        expect(likes).to eq("Jacob and Alex like this")
      end  
    end

    context 'when 3 people like it' do
      it "should show all names" do
        wli = WLI.new
        wli.names = ["Max", "John", "Mark"]
        likes = wli.likes

        expect(likes).to eq("Max, John and Mark like this")
      end  
    end

    context 'when 1 person likes it' do
      it "should show one name" do
        wli = WLI.new
        wli.names = ["Peter"]
        likes = wli.likes

        expect(likes).to eq("Peter likes this")
      end  
    end

    context 'when 0 people like it' do
      it "should show no name" do
        wli = WLI.new
        likes = wli.likes

        expect(likes).to eq("No one likes this")
      end  
    end

    context 'when more than 3 people like it' do
      it "should show 2 names and truncate the rest" do
        wli = WLI.new
        wli.names = ["Alex", "Jacob", "Mark", "Max"]
        likes = wli.likes

        expect(likes).to eq("Alex, Jacob and 2 others like this")
      end  
    end
  end
end
