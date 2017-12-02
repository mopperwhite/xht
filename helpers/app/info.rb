#!/usr/bin/env ruby
#encoding=utf-8
class WebViewer
  get '/api/info/:id' do
    doujinshi = Doujinshi.first(id: params[:id].to_i)
    halt 401 if doujinshi.nil?
    doujinshi.doujinshi_meta.to_struct.to_h.to_json
  end

  get '/api/images/:id' do
    doujinshi = Doujinshi.first(id: params[:id].to_i)
    halt 401 if doujinshi.nil?
    doujinshi.images.to_json
  end

end