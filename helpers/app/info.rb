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



  get '/api/image' do
    content_type 'image/png'
    id = params[:id].to_i
    filename = params[:filename]
    resize = params.has_key? :resize

    doujinshi = Doujinshi.first(id: id)
    halt 401, 'File not found.' unless doujinshi &&
                    (doujinshi.doujinshi_meta.cover == filename ||
                    DoujinshiImage.count(
                      doujinshi_id: doujinshi.id, 
                      filename:     filename
                    )!=0)

    fp = File.join(KeyValue['save_dir'], doujinshi.dir, filename)
    halt 401, 'File lost.' unless File.exists?(fp)
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