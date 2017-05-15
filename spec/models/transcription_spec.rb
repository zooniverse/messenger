RSpec.describe Transcription, type: :model do
  context 'validating' do
    it 'has a valid project' do
      no_project = build(:transcription, project: nil)
      expect(no_project).to_not be_valid
    end

    it 'has a valid status' do
      invalid_state = build :transcription, status: 'invalid'
      expect(invalid_state).to_not be_valid
    end
  end
end
