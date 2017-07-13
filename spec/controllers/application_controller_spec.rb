RSpec.describe ApplicationController, type: :controller do
  it_behaves_like 'a controller authenticating', :root
  it_behaves_like 'a controller paginating'

  describe '#root' do
    subject{ response }

    context 'with application/json' do
      before(:each){ get :root, format: :json }
      its(:content_type){ is_expected.to eql 'application/json' }
    end

    context 'with application/vnd.api+json' do
      before(:each){ get :root, format: :json_api }
      its(:content_type){ is_expected.to eql 'application/json' }
    end

    it 'returns the revision' do
      get :root, format: :json_api
      binding.pry
    end
  end

  describe '#resource_ids' do
    let(:params){ { } }
    let(:controller_params){ ActionController::Parameters.new params }

    subject{ controller.resource_ids }

    before(:each) do
      allow(controller).to receive(:params).and_return controller_params
    end

    context 'without an id' do
      it{ is_expected.to be_empty }
    end

    context 'with an integer' do
      let(:params){ { id: 123 } }
      it{ is_expected.to eql [123] }
    end

    context 'with a single id string' do
      let(:params){ { id: '123' } }
      it{ is_expected.to eql [123] }
    end

    context 'with a comma separated string' do
      let(:params){ { id: '123,456' } }
      it{ is_expected.to eql [123, 456] }
    end

    context 'with a mess' do
      let(:params){ { id: ',;,123,456.123,\'foo\'' } }
      it{ is_expected.to eql [123, 456] }
    end
  end

  describe '#auth_token' do
    let(:token){ nil }
    subject{ controller.auth_token }

    before(:each) do
      allow(controller.request).to receive(:headers).and_return('Authorization' => token) if token
    end

    context 'with an authorization header' do
      let(:token){ 'Bearer test' }
      it{ is_expected.to eql 'test' }
    end

    context 'without an authorization header' do
      it{ is_expected.to be_nil }
    end
  end

  describe '#set_roles' do
    let(:user){ create :user }
    let(:client_double){ double roles: { 'foo' => ['bar'] } }

    context 'with a user' do
      before(:each) do
        allow(controller).to receive(:current_user).and_return user
      end

      it 'should fetch roles' do
        expect(PanoptesClient).to receive(:new).and_return client_double
        expect(client_double).to receive :roles
        controller.set_roles
      end

      it 'should set the current user roles' do
        allow(PanoptesClient).to receive(:new).and_return client_double
        controller.set_roles
        expect(controller.current_user.roles).to eql 'foo' => ['bar']
      end
    end

    context 'without a user' do
      it 'should not fetch roles' do
        expect(PanoptesClient).to_not receive(:new)
        controller.set_roles
      end
    end
  end
end
