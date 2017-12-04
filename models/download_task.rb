#!/usr/bin/env ruby
#encoding=utf-8
class DownloadTask
  include DataMapper::Resource
  property :id,         Serial
  property :url,        String, length: 0..400
  property :dir,        String, length: 0..400
  property :last_image, Integer,  default: 0
  property :tag,        String
  property :status,     Enum[:new, :initialized, :finished]
  
  belongs_to  :doujinshi
  has n,      :stored_queue, :constraint => :destroy
  
  def queue(type)
    DownloadTaskQueue.new self, type
  end

  def finish!
    raise RuntimeError("Task can not be finished when is not initialized.") if status != :initialized
    self.status = :finished
    save
  end

  def next_image_index!
    i = self.last_image
    self.last_image += 1
    save
    i
  end

  def add_image(url, index, f)
    DoujinshiImage.create(
      doujinshi_id: doujinshi_id,
      index: index,
      filename: f
    )
  end
end

