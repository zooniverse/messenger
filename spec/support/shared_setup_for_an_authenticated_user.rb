RSpec.shared_examples_for 'an authenticated user' do
  let(:current_user){ create :user }

  before(:each) do
    allow(controller).to receive(:current_user).and_return current_user
  end
end
