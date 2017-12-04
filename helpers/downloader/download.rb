#!/usr/bin/env ruby
#encoding=utf-8
module Downloader
  
  def download(doujinshi_dir = '.', server_mode = false)
    @doujinshi_dir = doujinshi_dir
    if @task.status == :new
      @meta = MetaInfo.new
      instance_exec(@task.url, &self.class.class_variable_get(:'@@first_page_proc'))
      @doujinshi.create_meta(@meta)
      @doujinshi.set_dir(dir_name)
      f = File.join(@doujinshi_dir, dir_name)
      Dir.mkdir(f) unless Dir.exists?(f) 
    else
      @meta = @doujinshi.get_meta
    end

    types = [:index_page, :image_page, :image]
    queues= types.map{|t| @task.queue(t)}
    pairs = types.zip(queues)
    @fiber = Fiber.new do
      until queues.all?(&:empty?)
        pairs.each do |t, q|
          next if q.empty?
          url = q.top
          instance_exec( url, &self.class.class_variable_get(:"@@#{t}_proc") )
          q.pop
          @messages.push "URL: #{url}"
          # $logger.debug 'Yield'
          Fiber.yield
          # $logger.debug 'Resumed'
        end
        Fiber.yield
      end
      finish!
    end
    if server_mode
      @fiber
    else
      while @fiber.alive?
        @fiber.resume
      end
    end
  end

  def finish!
    File.write (File.join @doujinshi_dir, dir_name, 'meta.yaml'), @meta.to_h.merge(
      images: @doujinshi.images
    ).to_yaml
    @task.finish!
  end

  def download_image(url, name)
    path = File.join(@doujinshi_dir, dir_name, name)
    FileUtils.remove_file(path) if File.exists?(path)
    agent.get(url).save(path)
  end
end