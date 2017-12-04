#!/usr/bin/env ruby
#encoding=utf-8
class WebViewer
  get '/api/downloading_tasks' do
    Doujinshi.all(Doujinshi.download_task.status.not => :finished).to_json
  end

  post '/api/download' do
    halt 401, 'URL needed.' if params[:url].nil?
    case URI(params[:url])
    when URI::HTTP, URI::HTTPS, URI::FTP
      downloader = Downloader.add_task(params[:url])
      if downloader
        DownloadServer.add_task(downloader)
        @@ws_room.global_broadcast("message", "Task Accepted: #{params[:url]}")
        @@ws_room.global_broadcast("update_download_status")
      else
        @@ws_room.global_broadcast("message", "Task Already Exists: #{params[:url]}")
      end
      {
        accepted: ! downloader.nil?
      }.to_json
    else
      halt 401, 'Invalid URI.'
    end
  end

  post '/api/import_by_filename' do
    halt 401 if params[:filename].nil? || params[:importer].nil?
    if File.exists? params[:filename]
      Importer.import(params[:importer], params[:filename])
    else
      halt 401, 'File not found.'
    end
  end

  # TODO: upload a file or dir
end