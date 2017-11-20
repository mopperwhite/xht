#!/usr/bin/env ruby
#encoding=utf-8
class StoredQueue
  include DataMapper::Resource
  property :id,         Serial
  property :type,       Enum[:index_page, :image_page, :image]
  property :url,        String, length: 0..400
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
    q = StoredQueue.new(
      download_task_id: @task.id,
      type:   @type,
      url:    url
    )
    q.save 
  end
  def top()
    item = StoredQueue.first(
      download_task_id: @task.id,
      type:   @type,
      finished: false
    )
    item.url
  end
  def pop()
    item = StoredQueue.first(
      download_task_id: @task.id,
      type:   @type,
      finished: false
    )
    url = item.url
    item.finished = true
    item.save
    url
  end
  def empty?
    StoredQueue.count(
      download_task_id: @task.id,
      type:   @type,
      finished: false
    ) == 0
  end
end