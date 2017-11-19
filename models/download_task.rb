#!/usr/bin/env ruby
#encoding=utf-8
class DownloadTask
  include DataMapper::Resource
  property :id,         Serial
  property :url,        String
  property :dir,        String
  property :last_image, Integer,  default: 0
  property :status,     Enum[:new, :initialized, :finished]
  
  belongs_to  :doujinshi
  has n,      :stored_queue
  
  def queue(type)
    DownloadTaskQueue.new self, type
  end

  def finishe!
    raise RuntimeError("Task can not be finished when is not initialized.") if status != :initialized
    self.status = :finished
    save
  end

  def add_image(url, index, f)
    DoujinshiImage.create(
      doujinshi_id: doujinshi_id,
      index: index,
      filename: f
    )
  end
end

