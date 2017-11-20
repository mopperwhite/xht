#!/usr/bin/env ruby
#encoding=utf-8
DownloaderProcNames = [:first_page, :index_page, :image_page, :image]
module DownloaderProc
  attr_reader :instances
  DownloaderProcNames.each do |n|
    define_method :"on_#{n}" do |&block|
      proc_name  = :"@@#{n}_proc"
      class_variable_set proc_name, block
    end
  end
end

module Downloader
  def _init_variables
    DownloaderProcNames.each do |n|
      add_mn = :"add_#{n}"
      next_mn= :"get_next_#{n}"
      queue_name  = :"@#{n}_queue"
      proc_name  = :"@@#{n}_proc"
      
      define_singleton_method(add_mn) do |url|
        # p n, url
        @task.queue(n).push(url)
        # instance_variable_get(queue_name).push(url)
      end unless self.class.method_defined? add_mn
      
      # define_singleton_method(next_mn) do |url|
      #   instance_variable_get(queue_name).pop(url)
      # end unless self.class.method_defined? next_mn

    end
  end

  # def _init_queues
  #   queue_name  = :"@#{n}_queue"
  #   instance_variable_set(queue_name,  @task.queue(n))
  # end
end