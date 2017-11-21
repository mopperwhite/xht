#!/usr/bin/env ruby
#encoding=utf-8
class WebViewer
  get '/api/keyvalues/get' do
    KeyValue.to_h.to_json
  end

  post '/api/keyvalues/set' do
    KeyValue.merge(params)
    true
  end
end