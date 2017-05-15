source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails'
gem 'puma'
gem 'pg'
gem 'rack-cors'
gem 'active_model_serializers'
gem 'json-schema'
gem 'json-schema_builder'
gem 'kaminari'
gem 'jwt'
gem 'pundit'

gem 'panoptes-client'

group :test do
  gem 'webmock', '~> 2.1'
  gem 'database_cleaner'
  gem 'faker'
  gem 'factory_girl_rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
end
