#!/usr/bin/env ruby
#encoding=utf-8

class WebViewer < Sinatra::Base

  set :public_folder, 'public'

  use Rack::Auth::Basic do |username, password|
    User.authorized?(username, password)
  end if KeyValue[:authorize]

  get '/' do
    send_file File.join('frontend', 'index.html')
  end

  get '/query' do
  end

  get '/info/:id' do
  end

  get '/image' do
    content_type 'image/png'
    id = params[:id].to_i
    filename = params[:filename]
    resize = params.has_key? :resize

    doujinshi = Doujinshi.first(id: id)
    halt 404 unless doujinshi &&
                    DoujinshiImage.count(
                      doujinshi_id: doujinshi.id, 
                      filename:     filename
                    )!=0

    fp = File.join(KeyValue['save_dir'], doujinshi.dir, filename)
    file = if resize
      width, height = params[:resize].split(?x).map(&:to_i)
      tempfile = Tempfile.new
      tempfile.close
      Magick::Image.read(fp)
        .first
        .crop_resized(width, height)
        .write(tempfile.path)
      tempfile.open
      tempfile
    else
      File.open fp
    end
    stream do |out|
      out << file.read
      file.close
      out.close
      file.unlink if file.is_a?(Tempfile)
    end
  end

end