RSpec.shared_examples_for 'a controller paginating' do
  let(:page_double){ double per: true }
  let(:scope_double){ double page: page_double }

  let(:params){ { } }
  let(:controller_params){ ActionController::Parameters.new params }

  before(:each) do
    allow(controller).to receive(:params).and_return controller_params
  end

  describe '#paginate' do
    it 'should use the page number' do
      expect(controller).to receive(:page).and_return 123
      controller.paginate scope_double
      expect(scope_double).to have_received(:page).with 123
    end

    it 'should use the page size' do
      expect(controller).to receive(:page_size).and_return 456
      controller.paginate scope_double
      expect(page_double).to have_received(:per).with 456
    end
  end

  describe '#page' do
    subject{ controller.page }

    context 'without a page' do
      it{ is_expected.to eql 1 }
    end

    context 'with a page' do
      let(:params){ { page: { number: 123 } } }
      it{ is_expected.to eql 123 }
    end
  end

  describe '#page_size' do
    subject{ controller.page_size }

    context 'without a page size' do
      it{ is_expected.to eql 10 }
    end

    context 'with a page size' do
      let(:params){ { page: { size: 123 } } }
      it{ is_expected.to eql 123 }
    end
  end
end
