RSpec.shared_examples_for 'a controller creating' do
  let(:authorized_user){ nil }
  let(:unauthorized_user){ nil }
  let(:current_user){ nil }

  let(:valid_params){ { } }
  let(:invalid_params){ { } }
  let(:current_params){ { } }

  let(:request!){ post :create, params: current_params }

  it_has_behavior_of 'an authenticated user' do
    describe '#create' do
      let(:current_user){ authorized_user }

      it 'should use the service' do
        expect(controller.service).to receive :create!
        request!
      end

      context 'when unauthorized' do
        let(:current_user){ unauthorized_user }
        let(:current_params){ invalid_params }

        it 'should be unauthorized' do
          request!
          expect(response).to be_unauthorized
        end

        it 'should return an error message' do
          request!
          expect(response.json[:error]).to include 'not allowed to create this'
        end
      end

      context 'when authorized' do
        let(:current_params){ valid_params }

        it 'should be okay' do
          request!
          expect(response).to be_ok
        end

        it 'should render the resource' do
          request!
          expect(response.json[:data]).to include :id, :attributes, :links
        end
      end
    end
  end
end
