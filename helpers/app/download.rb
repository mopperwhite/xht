#!/usr/bin/env ruby
#encoding=utf-8
class WebViewer
  get '/api/downloading_tasks' do
    Doujinshi.all(Doujinshi.download_task.status.not => :finished).to_json
  end

  post '/api/download' do
    p params
    halt 401, 'URL needed.' if params[:url].nil?
    case URI(params[:url])
    when URI::HTTP, URI::HTTPS, URI::FTP
      Downloader.add_task(params[:url])
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