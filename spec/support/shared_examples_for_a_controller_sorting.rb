RSpec.shared_examples_for 'a controller sorting' do |attributes:, default:|
  let(:params){ { } }
  let(:controller_params){ ActionController::Parameters.new params }

  before(:each) do
    allow(controller).to receive(:params).and_return controller_params
  end

  describe '#sort' do
    let(:allowed_sort_params){ { } }
    let(:scope_double){ double order: true }

    before(:each) do
      allow(controller).to receive(:allowed_sort_params).and_return allowed_sort_params
    end

    context 'without a specified sort' do
      it 'should use the default sort' do
        expect(controller).to receive(:default_sort).and_return foo: :asc
        expect(scope_double).to receive(:order).with foo: :asc
        controller.sort scope_double
      end
    end

    context 'with a specified sort' do
      let(:allowed_sort_params){ { bar: :desc } }

      it 'should use the default sort' do
        expect(scope_double).to receive(:order).with bar: :desc
        controller.sort scope_double
      end
    end
  end

  describe '#default_sort' do
    subject{ controller.default_sort }
    it{ is_expected.to eql default }

    it 'should use the serializer class' do
      expect(controller).to receive_message_chain 'serializer_class.default_sort'
      subject
    end
  end

  describe '#allowed_sort_params' do
    let(:allowed_attributes){ attributes | [:id] }
    let(:valid_sort_params){ allowed_attributes.map{ |attr| [attr, :asc] } }
    let(:sort_params){ valid_sort_params }
    subject{ controller.allowed_sort_params }

    before(:each) do
      allow(controller).to receive(:sort_params).and_return sort_params
    end

    context 'with valid attributes' do
      it{ is_expected.to eql Hash[*valid_sort_params.flatten] }
    end

    context 'with some invalid attributes' do
      let(:sort_params){ valid_sort_params + [:foo, :asc] }
      it{ is_expected.to eql Hash[*valid_sort_params.flatten] }
    end

    context 'with no valid attributes' do
      let(:sort_params){ [[:foo, :asc]] }
      it{ is_expected.to be_empty }
    end
  end

  describe '#sort_params' do
    subject{ controller.sort_params }

    context 'without sort params' do
      it{ is_expected.to be_empty }
    end

    context 'with a single sort param' do
      context 'without direction' do
        let(:params){ { sort: 'id' } }
        it{ is_expected.to eql [[:id, :asc]] }
      end

      context 'when ascending' do
        let(:params){ { sort: '+id' } }
        it{ is_expected.to eql [[:id, :asc]] }
      end

      context 'when descending' do
        let(:params){ { sort: '-id' } }
        it{ is_expected.to eql [[:id, :desc]] }
      end
    end

    context 'with mixed sort params' do
      let(:params){ { sort: 'foo,+bar,-baz' } }
      it{ is_expected.to eql [[:foo, :asc], [:bar, :asc], [:baz, :desc]] }
    end
  end
end
