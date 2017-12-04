#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/file_cache'
module WebViewerImageHelper
  module_function
  def load_file(path, fp, resize, enhance)
    halt 404 unless File.exists?(fp)
    if resize || enhance
      if FileCache.exists?(path)
        file = FileCache.get(path)
        file.open
        file
      else
        tempfile = Tempfile.new
        tempfile.close
        img = Magick::Image.read(fp).first
        if resize
          width, height = resize
          img = img.crop_resized(width, height)
        end
        case enhance
          when 'normalize'
            img = img.normalize
          when 'equalize'
            img = img.equalize
        end
        img.write(tempfile.path)
        tempfile.open
        FileCache.add(path, tempfile)
        tempfile
      end
    else
      File.open fp
    end
  end
end

class WebViewer
  get '/api/image' do
    etag '', :new_resource => true
    content_type 'image/png'
    expires 10.hours.from_now
    # cache_control :public, :max_age => 36000
    expires 3600, :public, :must_revalidate
    id =        params[:id].to_i
    filename =  params[:filename]
    resize =    params[:resize]&.split('x')&.map(&:to_i)
    enhance=    params[:enhance]

    doujinshi = Doujinshi.first(id: id)
    halt 401, 'File not found.' unless doujinshi &&
                    (doujinshi.doujinshi_meta.cover == filename ||
                    DoujinshiImage.count(
                      doujinshi_id: doujinshi.id, 
                      filename:     filename
                    )!=0)

    fp = File.join(KeyValue['save_dir'], doujinshi.dir, filename)
    halt 401, 'File lost.' unless File.exists?(fp)
    last_modified(File.mtime(fp))
    file = WebViewerImageHelper.load_file(request.fullpath, fp, resize, enhance)
    file.close
    send_file file.path
    # stream do |out|
    #   out << file.read
    #   file.close
    #   out.close
    # end
  end
end