RSpec.shared_examples_for 'a controller filtering' do |attributes:|
  let(:params){ { } }

  before(:each) do
    allow(controller).to receive(:params).and_return params
  end

  describe '#filter' do
    let(:scope_double){ double.as_null_object }
    let(:filter_params){ { } }
    subject{ controller.filter scope_double }

    before(:each) do
      allow(controller).to receive(:allowed_filter_params).and_return filter_params
    end

    context 'without a filter' do
      it 'should not filter' do
        expect(scope_double).to_not receive :where
        subject
      end
    end

    context 'with a filter' do
      let(:filter_params){ { foo: 'bar', bar: 'baz' } }

      it 'should filter' do
        expect(scope_double).to receive(:where).once.ordered.with foo: 'bar'
        expect(scope_double).to receive(:where).once.ordered.with bar: 'baz'
        subject
      end
    end
  end

  describe '#allowed_filter_params' do
    let(:valid_filters){ Hash[*attributes.map{ |attr| [attr.to_sym, 123] }.flatten] }
    subject{ controller.allowed_filter_params }

    context 'without params' do
      it{ is_expected.to be_empty }
    end

    context 'with params' do
      let(:params){ { filter: { foo: 'bar' }.merge(valid_filters) } }
      it{ is_expected.to eql valid_filters }
    end
  end

  describe '#filter_params' do
    subject{ controller.filter_params}

    context 'without params' do
      it{ is_expected.to be_empty }
    end

    context 'with params' do
      let(:params){ { filter: { foo: 'bar' } } }
      it{ is_expected.to eql foo: 'bar' }
    end
  end
end
