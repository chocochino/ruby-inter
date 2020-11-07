require './controllers/category_controller.rb'

describe CategoryController do
  describe '#new' do
    it 'should show new category page' do
      controller = CategoryController.new
      response = controller.new_category
      expected_view = ERB.new(File.read("./views/category/new.erb"))
      expect(response).to eq(expected_view.result)
    end
  end

  describe '#show' do
    context 'invalid ID' do
      it 'should show error page' do
        controller = CategoryController.new
        response = controller.show(-1)
        expected_view = ERB.new(File.read("./views/error.erb"))
        expect(response).to eq(expected_view.result)
      end
    end
  end

  describe '#show' do
    context 'invalid ID' do
      it 'should show error page' do
        controller = CategoryController.new
        response = controller.show(-1)
        expected_view = ERB.new(File.read("./views/error.erb"))
        expect(response).to eq(expected_view.result)
      end
    end
  end

end
