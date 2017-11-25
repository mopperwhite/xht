#!/usr/bin/env ruby
#encoding=utf-8
require "sinatra/reloader"

class WebViewer < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  set :public_folder, 'public'

  use Rack::PostBodyContentTypeParser

  use Rack::Auth::Basic do |username, password|
    p username, password
    User.authorized?(username, password)
  end if KeyValue[:authorize]

  get '/' do
    send_file File.join('frontend', 'index.html')
  end

end

Dir['./helpers/app/*.rb'].each do |r|
  require r
end