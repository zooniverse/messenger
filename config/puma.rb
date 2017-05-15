#!/usr/bin/env puma

env = ENV['RAILS_ENV']

if env != 'development' && env != 'test'
  directory '/rails_app'
end

if env == 'staging'
  threads 2, 4
else
  threads 2, 8
end

worker_timeout 10
bind 'tcp://0.0.0.0:81'
