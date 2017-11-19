#!/usr/bin/env ruby
#encoding=utf-8

require './helpers/downloader/class'
require './helpers/downloader/helper'
require './helpers/downloader/matchable'
require './helpers/downloader/proc'
require './helpers/downloader/agent'
require './helpers/downloader/download'


$downloaders = []
module Downloader
  [DownloadHelper, DownloaderAgent, DownloaderDownload, DownloaderProcInstance].each do |m|
    include m
  end
  attr_reader :meta, :agent, :task

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

  def Downloader.download(url, dir = KeyValue['save_dir'])
    doujinshi = Doujinshi.create(url: url)
    start(doujinshi, dir)
  end

  def Downloader.recover(dir = KeyValue['save_dir'])
    Doujinshi.all(:download_task.status == :initialized).each do |doujinshi|
      start(doujinshi, dir)
    end
  end

  def Downloader.start(doujinshi, dir)
    down_class  = $downloaders.detect{|d| d.match? doujinshi.url}
    raise RuntimeError.new "No matched donwloader for: #{url}" if down_class.nil?
    downloader  = down_class.new(doujinshi)
    downloader.download(dir)
  end
end

require './helpers/downloader/load'