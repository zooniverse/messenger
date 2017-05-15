RSpec.describe ProjectSchema, type: :schema do
  describe '#create' do
    let(:schema_method){ :create }
    its(:type){ is_expected.to eql 'object' }
    its(:required){ is_expected.to eql ['data'] }

    with 'properties .data' do
      its(:type){ is_expected.to eql 'object' }
      its(:required){ is_expected.to match_array %w(id slug) }
      its(:additionalProperties){ is_expected.to be false }

      with :properties do
        its(:slug){ is_expected.to eql type: 'string' }
      end
    end
  end
end
