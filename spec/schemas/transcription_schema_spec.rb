RSpec.describe TranscriptionSchema, type: :schema do
  shared_examples_for 'a transcription schema' do
    its(:type){ is_expected.to eql 'object' }
    its(:required){ is_expected.to eql ['data'] }

    with 'properties .data' do
      its(:type){ is_expected.to eql 'object' }
      its(:additionalProperties){ is_expected.to be false }

      with :properties do
        its(:project_id){ is_expected.to eql id_schema }
        its(:text){ is_expected.to eql type: 'string' }
        its(:status){ is_expected.to eql enum: %w(accepted rejected amended unreviewed) }
      end
    end
  end

  describe '#create' do
    let(:schema_method){ :create }
    it_behaves_like 'a transcription schema'

    with 'properties .data' do
      its(:required){ is_expected.to eql %w(id project_id text status) }
    end
  end

  describe '#update' do
    let(:schema_method){ :update }
    it_behaves_like 'a transcription schema'

    with 'properties .data' do
      its(:required){ is_expected.to be_nil }
    end
  end
end
