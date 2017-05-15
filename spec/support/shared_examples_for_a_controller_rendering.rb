RSpec.shared_examples_for 'a controller rendering' do |methods: [:show, :index]|
  let(:resource){ controller.resource }
  let!(:resource_instance){ create resource.model_name.singular }

  if methods.include?(:show)
    describe '#show' do
      it 'should find the resource' do
        expect(resource).to receive(:where).with(id: [resource_instance.id]).and_return resource_instance
        get :show, params: { id: resource_instance.id }
      end

      it 'should render' do
        get :show, params: { id: resource_instance.id }
        expect(response.json.dig(:data, 0, :id)).to eql resource_instance.id.to_s
      end
    end
  end

  if methods.include?(:index)
    describe '#index' do
      it 'should filter the resource' do
        expect(controller).to receive(:filter).and_call_original
        get :index
      end

      it 'should sort the resource' do
        expect(controller).to receive(:sort).and_call_original
        get :index
      end

      it 'should paginate the resource' do
        expect(controller).to receive(:paginate).and_call_original
        get :index
      end

      it 'should render' do
        get :index
        expect(response.json.dig(:data, 0, :id)).to eql resource_instance.id.to_s
      end
    end
  end
end
