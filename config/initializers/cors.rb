Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any,
      methods: [:options, :get, :post, :put, :delete],
      expose: ['ETag']
  end
end
