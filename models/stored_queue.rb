#!/usr/bin/env ruby
#encoding=utf-8
class StoredQueue
  include DataMapper::Resource
  property :id,         Serial
  property :type,       Enum[:index_page, :image_page, :image]
  property :url,        String
  property :finished,   Boolean, default: false

  belongs_to :download_task

  def next_image_index!
    index = download_task.last_image
    download_task.last_image += 1
    download_task.save
    index
  end
end

class DownloadTaskQueue
  def initialize(task, type)
    @type = type
    @task = task
  end
  def push(url)
    StoredQueue.create(
      download_task_id: @task.id,
      type:   @type,
      url:    url
    )
  end
  def pop()
    item = first(
      download_task_id: @task.id,
      type:   @type
    )
    url = item.url
    item.finished = true
    item.save
    url
  end
  def empty?
    first(
      download_task_id: @task.id,
      type:   @type
    ) == 0
  end
end