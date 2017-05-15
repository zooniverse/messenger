Rails.application.routes.draw do
  root 'application#root'
  defaults format: 'json' do
    resources :projects
    resources :transcriptions
  end
end
