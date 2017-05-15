RSpec.describe ProjectsController, type: :controller do
  it_behaves_like 'a controller authenticating'
  it_behaves_like 'a controller authorizing'
  it_behaves_like 'a controller paginating'
  it_behaves_like 'a controller sorting', attributes: [], default: :id
  it_behaves_like 'a controller filtering', attributes: [:slug]
  it_behaves_like 'a controller rendering'

  it_behaves_like 'a controller creating' do
    before(:each) do
      stub_request(:get, "https://panoptes-staging.zooniverse.org/api/project_roles?page_size=100&user_id=#{ authorized_user.id }").to_return({
        status: 200,
        body: JSON.dump(project_roles: [{
          roles: ['foo', 'owner'],
          links: {
            project: '123'
          }
        }, {
          roles: ['foo', 'scientist'],
          links: {
            project: '456'
          }
        }],
        meta: {
          project_roles: {
            next_href: nil
          }
        })
      })

      stub_request(:get, 'https://panoptes-staging.zooniverse.org/api/projects?cards=true&slug=works').to_return({
        status: 200,
        body: JSON.dump(projects: [{ id: 123, slug: 'works' }])
      })
    end

    let(:authorized_user){ create :user, :admin }
    let(:valid_params) do
      {
        data: {
          attributes: {
            slug: 'works'
          }
        }
      }
    end
  end
end
