#!/usr/bin/env ruby
#encoding=utf-8
require 'thread'

require './helpers/structs'
require './helpers/downloader/helper'
require './helpers/downloader/matchable'

require './helpers/downloader/proc'

$downloaders = []

module Downloader
  attr_reader :meta, :agent, :task, :fiber, :messages, :doujinshi

  def initialize(doujinshi, dir)
    initialize_agent()
    @doujinshi = doujinshi
    @task      = doujinshi.download_task
    @messages  = Queue.new
    @doujinshi_dir = dir
    
    _init_variables()
    # init_meta()
  end

  # INCLUDED
  def Downloader.included(mod)
    $downloaders.push mod
    [Matchable, DownloaderProc].each do |x|
      mod.extend x
    end
  end
  
end

class << Downloader

  def add_task(url, tag = nil)
    if exists?(url)
      nil
    else
      doujinshi = Doujinshi.add(url, tag)
      downloader = get_downloader_by_doujinshi(doujinshi, KeyValue['save_dir'])
      # downloader.init_meta
      downloader
    end
  end

  def exists?(url)
    Doujinshi.count(url: url) != 0
  end

  def start()
    while has_task?
      downloader = start_top_task!(false)
      p downloader.task.url
    end
  end

  def has_task?()
    Doujinshi.has_task?
  end

  def top_task
    Doujinshi.top_task
  end

  def start_top_task!(server_mode)
    doujinshi = top_task
    download_by_doujinshi(doujinshi, server_mode, KeyValue['save_dir'])
  end

  def get_downloader_by_doujinshi(doujinshi, dir)
    down_class  = $downloaders.detect{|d| d.match?(doujinshi.url, doujinshi.download_task.tag)}
    raise RuntimeError.new "No matched donwloader for: #{doujinshi.url}" if down_class.nil?
    downloader  = down_class.new(doujinshi, dir)
  end

  def download_by_doujinshi(doujinshi, server_mode, dir)
    downloader = get_downloader_by_doujinshi(doujinshi, dir)
    downloader.download(server_mode)
    downloader
  end
end

require './helpers/downloader/agent'
require './helpers/downloader/download'
# require './helpers/downloader/load'