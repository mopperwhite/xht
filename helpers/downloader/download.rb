#!/usr/bin/env ruby
#encoding=utf-8
module DownloaderDownload
  def download(doujinshi_dir = '.')
    @doujinshi_dir = doujinshi_dir
    p @task.status
    if @task.status == :new
      @meta = MetaInfo.new
      instance_exec(@task.url, &@@first_page_proc)
      @doujinshi.create_meta(@meta)
      @doujinshi.set_dir(dir_name)
    else
      @meta = @doujinshi.get_meta
    end

    types = [:index_page, :image_page, :download_image]
    queues= types.map{|t| @task.queue(t)}
    pairs = types.zip(queues)
    while queues.all? &:empty?
      pairs.each do |t, q|
        next if q.empty?
        url = q.pop
        instance_exec( url, &class_variable_get(:"@@#{t}_proc") )
      end
    end
    
    finish!
  end

  def finish!
    File.write (File.join @doujinshi_dir, dir_name), @meta.to_h.merge(
      images: @doujinshi.images
    ).to_yaml
    @doujinshi.finish!
  end

  def download_image(url, name)
    path = File.join(@doujinshi_dir, dir_name, name) 
    agent.get(url).save(path)
  end
end