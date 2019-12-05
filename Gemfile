source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', "~> 5.1"
gem 'puma', "~> 3.12"
gem 'pg', "~> 0.20"
gem 'rack-cors', "~> 0.4"
gem 'active_model_serializers', "~> 0.10"
gem 'json-schema', "~> 2.8"
gem 'json-schema_builder', "~> 0.0"
gem 'kaminari', "~> 1.0"
gem 'jwt', "~> 1.5"
gem 'pundit', "~> 1.1"
gem 'rollbar', "~> 2.15"

gem 'panoptes-client', "~> 0.3"

group :test do
  gem 'webmock', "~> 3.0"
  gem 'database_cleaner', "~> 1.6"
  gem 'faker', "~> 1.7"
  gem 'factory_girl_rails', "~> 4.8"
end

group :development, :test do
  gem 'rspec', "~> 3.6"
  gem 'rspec-rails', "~> 3.6"
  gem 'rspec-its', "~> 1.2"
  gem 'pry', "~> 0.10"
  gem 'pry-rails', "~> 0.3"
  gem 'pry-byebug', "~> 3.4"
end
