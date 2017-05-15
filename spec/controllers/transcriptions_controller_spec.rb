RSpec.describe TranscriptionsController, type: :controller do
  before(:each) do
    allow(controller).to receive :set_roles
  end

  it_behaves_like 'a controller authenticating'
  it_behaves_like 'a controller authorizing'
  it_behaves_like 'a controller paginating'
  it_behaves_like 'a controller sorting', attributes: [], default: :id
  it_behaves_like 'a controller filtering', attributes: [:project_id, :status]

  it_has_behavior_of 'an authenticated user' do
    let(:transcription){ create :transcription }
    let(:current_user){ create :user, roles: { transcription.project_id => ['owner'] } }

    it_behaves_like 'a controller rendering' do
      let!(:resource_instance){ transcription }
    end
  end

  it_behaves_like 'a controller creating' do
    let(:project){ create :project }
    let(:authorized_user){ create :user, :admin }
    let(:valid_params) do
      {
        data: {
          attributes: {
            id: '12345',
            status: 'unreviewed',
            text: 'MY DEAREST MARTHA'
          }, relationships: {
            project: {
              data: {
                type: 'projects',
                id: project.id.to_s
              }
            }
          }
        }
      }
    end
  end

  it_behaves_like 'a controller updating' do
    let(:authorized_user){ create :user, :admin }
    let(:transcription){ create :transcription }
    let(:valid_params) do
      {
        id: transcription.id.to_s,
        data: {
          id: transcription.id.to_s,
          attributes: {
            text: 'OH NO I WAS STABBED WITH A BAYONET',
            status: 'accepted'
          }
        }
      }
    end
  end
end
