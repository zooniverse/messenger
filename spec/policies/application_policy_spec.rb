RSpec.describe ApplicationPolicy, type: :policy do
  let(:user){ }
  let(:records){ [] }
  let(:policy){ ApplicationPolicy.new user, records }
  subject{ policy }

  describe 'default actions' do
    it_behaves_like 'a policy permitting', :index, :show
    it_behaves_like 'a policy forbidding', :create, :update, :destroy
  end

  describe '#privileged_project_ids' do
    subject{ policy.privileged_project_ids }

    context 'without roles' do
      it{ is_expected.to eql [] }
    end

    context 'with non-provileged roles' do
      let(:user){ create :user, roles: { 1 => ['foo'] } }
      it{ is_expected.to eql [] }
    end

    context 'with privileged roles' do
      let(:user) do
        create :user, roles: {
          1 => ['scientist'],
          2 => ['owner'],
          3 => ['tester'],
          4 => ['collaborator'],
          5 => ['nobody'],
          6 => ['owner', 'collaborator']
        }
      end

      it{ is_expected.to eql [2, 4, 6] }
    end
  end

  context 'without a user' do
    it{ is_expected.to_not be_logged_in }
    it{ is_expected.to_not be_admin }
  end

  context 'with a user' do
    let(:user){ create :user }
    it{ is_expected.to be_logged_in }
    it{ is_expected.to_not be_admin }
  end

  context 'with an admin' do
    let(:user){ create :user, :admin }
    it{ is_expected.to be_logged_in }
    it{ is_expected.to be_admin }
  end
end
