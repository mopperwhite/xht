#!/usr/bin/env ruby
#encoding=utf-8

require './helpers/structs'
require './helpers/downloader/helper'
require './helpers/downloader/matchable'

require './helpers/downloader/proc'

$downloaders = []

module Downloader
  attr_reader :meta, :agent, :task, :fiber

  def initialize(doujinshi)
    initialize_agent()
    @doujinshi = doujinshi
    @task      = doujinshi.download_task
    
    _init_variables()
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
    doujinshi = Doujinshi.add(url, tag)
  end

  def exists?(url)
    Doujinshi.count(url: url) != 0
  end

  def start()
    while has_task?
      start_top_task!
    end
  end

  def has_task?()
    Doujinshi.has_task?
  end

  def top_task
    Doujinshi.top_task
  end

  def start_top_task!
    doujinshi = top_task
    download_by_doujinshi(doujinshi, false, KeyValue['save_dir'])
  end

  def download_by_doujinshi(doujinshi, server_mode, dir)
    down_class  = $downloaders.detect{|d| d.match?(doujinshi.url, doujinshi.download_task.tag)}
    raise RuntimeError.new "No matched donwloader for: #{url}" if down_class.nil?
    downloader  = down_class.new(doujinshi)
    downloader.download(dir, server_mode)
    downloader
  end
end

require './helpers/downloader/agent'
require './helpers/downloader/download'
require './helpers/downloader/load'