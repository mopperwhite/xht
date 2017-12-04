#!/usr/bin/env ruby
#encoding=utf-8
require "sinatra/reloader"

class WebViewer < Sinatra::Base

  use Rack::Session::Moneta, store: Moneta.new(:DataMapper, setup: $database_path)

  # configure :development do
  configure do
    register Sinatra::Reloader
  end

  set :public_folder, 'public'

  # use Rack::Session::Pool
  use Rack::PostBodyContentTypeParser

  # use Rack::Auth::Basic do |username, password|
  #   p username, password
  #   User.authorized?(username, password)
  # end if KeyValue[:authorize]

  before do
    unless !KeyValue['authorize'] || 
            request.fullpath == '/api/login' || 
            request.fullpath == '/' || 
            request.fullpath == '/io' || 
            request.fullpath == '/api/accesscode' || 
            session[:username]
      halt 401, 'Not a member.'
    end
  end

  get '/' do
    send_file File.join('frontend', 'index.html')
  end

  post '/api/login' do
    username = params[:username]
    password = params[:password]
    if User.authorized?(username, password)
      session[:username] = username
      true.to_json
    else
      halt 401, "Invalid User."
    end
  end

  get '/api/accesscode' do
    p KeyValue['authorize']
    if !KeyValue['authorize']
      {
        authorization: false,
        accesscode: nil
      }
    elsif session[:username].nil?
      {
        authorization: true,
        accesscode: nil
      }
    else
      {
        authorization: true,
        accesscode: AccessCode.first_or_create(session[:username])
      }
    end.to_json
  end

end

Dir['./helpers/app/*.rb'].each do |r|
  require r
end