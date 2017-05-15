require 'spec_helper'

RSpec.shared_examples_for 'a controller authenticating' do |controller_action = :index|
  context 'without a user' do
    before(:each){ get controller_action }
    its(:current_user){ is_expected.to be nil }
  end

  context 'with a user' do
    let(:current_user){ create :user }

    before :each do
      allow(Authenticator).to receive(:decode).with('token').and_return [{
        'data' => { 'id' => current_user.id, 'login' => current_user.login }
      }]

      @request.headers['Authorization'] = 'Bearer token'
      get controller_action
    end

    its(:current_user){ is_expected.to eql current_user }
  end
end
