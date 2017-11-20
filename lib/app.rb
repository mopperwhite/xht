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

  get '/io' do
  end

  get '/api/query' do
    query = {
      :unique => true
    }
    
    and_query = [] 
    
    if params[:range]
      from, to = params[:range].split('-').map(&:to_i)
      query.merge(offset: from, limit: to-from)
    end
    
    if params[:title]
      t_query = params[:tags].split.map do |t|
        Doujinshi.all(Doujinshi.doujinshi_title.title.like => "%#{t}%")
      end
      and_query.push(t_query.reduce(&:&))
    end
    
    if params[:character]
      query[Doujinshi.doujinshi_character.name] = "%#{params[:character]}%"
    end
    
    if params[:characters]
      c_query = params[:characters].split('|').map do |t|
        Doujinshi.all(Doujinshi.doujinshi_character.name => t)
      end
      and_query.push(t_query.reduce(&:&))
    end
    
    if params[:tags]
      or_query = params[:tags].split('|').map do |t|
        Doujinshi.all(Doujinshi.doujinshi_tag.tag => t)
      end
      and_query.push(or_query.reduce(&:+))
    end
    
    [:author, :description, :group, :language, :category].each do |t|
      next if params[t].nil?
      query[t.like] = "%#{params[t]}%"
    end

    ds = and_query.empty? ?
      Doujinshi.all(query) :
      Doujinshi.all(query) & and_query.reduce(&:+)
    ds
      .map(&:doujinshi_meta)
      .map(&:to_struct)
      .map(&:to_h)
      .to_json
  end

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

  get '/api/keyvalues/get' do
    KeyValue.to_h.to_json
  end

  post '/api/keyvalues/set' do
    KeyValue.merge(params)
    true
  end

  get '/api/image' do
    content_type 'image/png'
    id = params[:id].to_i
    filename = params[:filename]
    resize = params.has_key? :resize

    doujinshi = Doujinshi.first(id: id)
    halt 401 unless doujinshi &&
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