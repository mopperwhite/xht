source 'https://gems.ruby-china.org'
gem 'bundler'
gem 'bcrypt'
gem 'mechanize'
gem 'sinatra',            require: 'sinatra/base'
gem 'data_mapper'
gem 'dm-sqlite-adapter',  require: false
gem 'dm-migrations'
gem 'tty-prompt',         require: 'tty/prompt'
gem 'dm-noisy-failures'
gem 'sinatra-websocket'
gem 'rmagick'
gem 'rack-contrib',       require: 'rack/contrib'
gem 'sinatra-reloader',   require: 'sinatra/reloader'
gem 'activesupport',      require: 'active_support/all'
gem 'moneta',             require: ['moneta', 'rack/session/moneta']
Dir['plugins/*/Gemfile'].each do |path|
  load path
end