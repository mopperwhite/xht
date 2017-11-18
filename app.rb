#!/usr/bin/env ruby
#encoding=utf-8

class WebViewer < Sinatra::Base

  use Rack::Auth::Basic do |username, password|
    User.authorized?(username, password)
  end if KeyValue[:authorize]

  get '/' do
    '233'
  end
end