RSpec.shared_examples_for 'a controller authorizing' do |methods: [:show, :index]|
  let(:resource){ controller.resource }
  let(:resource_scope){ controller.resource_scope }
  let(:resource_instance){ create controller.resource.model_name.singular }

  if methods.include?(:show)
    describe '#show' do
      it 'should authorize the request' do
        expect(controller).to receive(:authorize).with ActiveRecord::Relation
        get :show, params: { id: resource_instance.id }
      end
    end
  end

  if methods.include?(:index)
    describe '#index' do
      it 'should authorize the request' do
        expect(controller).to receive(:authorize).with resource
        get :index
      end

      it 'should use the policy scope' do
        expect(controller).to receive(:policy_scope).with(resource_scope).and_return resource_scope
        get :index
      end
    end
  end
end
