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
  
  get '/api/initialized' do
    DoujinshiMeta.all(
      DoujinshiMeta.doujinshi.download_task.status => :initialized
    ).map do |meta|
      meta.to_struct.to_h.merge(
        id: meta.doujinshi_id
      )
    end.to_json
  end

  post '/api/delete' do
    doujinshi = Doujinshi.first(id: params[:id].to_i)
    halt 401 if doujinshi.nil?
    finished = doujinshi.download_task.status == :finished
    DownloadServer.stop unless finished
    doujinshi.delete
    DownloadServer.start unless finished
    true.to_json
  end

end