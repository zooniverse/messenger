RSpec.describe ApplicationService, type: :service do
  let(:current_user){ create :user, :admin }
  let(:params){ { } }

  let(:controller_double) do
    double({
      current_user: current_user,
      params: params,
      resource: Transcription,
      schema_class: TranscriptionSchema,
      serializer_class: TranscriptionSerializer
    })
  end

  let(:service){ ApplicationService.new controller_double }
  subject{ service }

  describe '#initialize' do
    let(:params){ { action: :create } }
    its(:action){ is_expected.to eql :create }
    its(:resource){ is_expected.to eql Transcription }
  end

  describe '#create!' do
    let(:project){ create :project }
    let(:params) do
      {
        action: :create,
        data: {
          attributes: {
            id: "12345", # the Panoptes subject ID
            project_id: project.id.to_s,
            text: 'works',
            status: 'unreviewed'
          }
        }
      }
    end

    it 'should initialize the instance' do
      subject.create!
      expect(subject.instance).to be_a Transcription
    end

    it 'should authorize' do
      expect(subject).to receive :authorize!
      subject.create!
    end

    it 'should validate' do
      expect(subject).to receive :validate!
      subject.create!
    end

    it 'should save the instance' do
      subject.create!
      expect(subject.instance.reload.text).to eql 'works'
    end
  end

  describe '#update!' do
    let(:transcription){ create :transcription }
    let(:params) do
      {
        action: :update,
        id: transcription.id.to_s,
        data: {
          attributes: {
            text: 'changed'
          }
        }
      }
    end

    it 'should find the instance' do
      subject.update!
      expect(subject.instance.id).to eql transcription.id
    end

    it 'should authorize' do
      expect(subject).to receive :authorize!
      subject.update!
    end

    it 'should validate' do
      expect(subject).to receive :validate!
      subject.update!
    end

    it 'should save the instance' do
      subject.update!
      expect(transcription.reload.text).to eql 'changed'
    end
  end

  describe '#destroy!' do
    let(:transcription){ create :transcription }
    let(:params) do
      {
        action: :destroy,
        id: transcription.id.to_s
      }
    end

    it 'should find the instance' do
      subject.destroy!
      expect(subject.instance).to be_a Transcription
    end

    it 'should authorize' do
      expect(subject).to receive :authorize!
      subject.destroy!
    end

    it 'should destroy the instance' do
      subject.destroy!
      expect{ transcription.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe '#authorize!' do
    let(:params){ { action: :create } }

    context 'when authorized' do
      it 'should not raise an error' do
        allow(service).to receive_message_chain('policy.create?').and_return true
        expect{ service.authorize! }.to_not raise_error
      end
    end

    context 'when unauthorized' do
      it 'should raise an error' do
        allow(service).to receive_message_chain('policy.create?').and_return false
        expect{ service.authorize! }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe '#validate!' do
    let(:params){ { action: :create } }

    before(:each) do
      expect(service).to receive :policy
    end

    context 'when valid' do
      it 'should not raise an error' do
        schema_double = double validate!: true
        expect(service).to receive_message_chain('schema_class.new.create').and_return schema_double
        expect{ service.validate! }.to_not raise_error
      end
    end

    context 'when invalid' do
      it 'should raise an error' do
        expect{ service.validate! }.to raise_error JSON::Schema::ValidationError
      end
    end
  end

  describe '#policy' do
    let(:instance){ create :transcription }

    before(:each) do
      allow(service).to receive(:instance).and_return instance
    end

    it 'should find the policy' do
      expect(Pundit).to receive(:policy!).with current_user, instance
      service.policy
    end
  end

  describe '#attributes' do
    subject{ service.attributes }

    context 'when empty' do
      it{ is_expected.to be_empty }
    end

    context 'without relationships' do
      let(:params) do
        {
          data: {
            attributes: {
              foo: '123'
            }
          }
        }
      end

      it{ is_expected.to eql foo: '123' }
    end

    context 'with relationships' do
      let(:params) do
        {
          data: {
            attributes: {
              foo: '123'
            },
            relationships: {
              project: {
                data: {
                  id: '456'
                }
              }
            }
          }
        }
      end

      it{ is_expected.to eql foo: '123', project_id: '456' }

      context 'as an array' do
        let(:params) do
          {
            data: {
              attributes: {
                foo: '123'
              },
              relationships: {
                project: {
                  data: [
                    { id: '456' },
                    { id: '789' }
                  ]
                }
              }
            }
          }
        end

        it{ is_expected.to eql foo: '123', project_ids: ['456', '789'] }
      end
    end
  end

  describe '#unauthorized!' do
    it 'should raise an error' do
      expect{ service.unauthorized! }.to raise_error Pundit::NotAuthorizedError
    end
  end
end
