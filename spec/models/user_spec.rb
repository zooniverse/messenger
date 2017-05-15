RSpec.describe User, type: :model do
  context 'validating' do
    it 'requires a login' do
      expect(build(:user, login: nil)).to_not be_valid
    end
  end
end
