#!/usr/bin/env ruby
#encoding=utf-8
class Doujinshi
  include DataMapper::Resource
  property  :id,   Serial
  property  :url,  String
  property  :dir,  String     

  has 1, :doujinshi_meta
  has 1, :download_task
  has n, :doujinshi_image

  def create_meta(meta)
    dm = DoujinshiMeta.from_struct(meta)
    dm.doujinshi_id = id
    dm.save
    download_task.status = :initialized
    download_task.save
  end

  def set_dir(dir)
    self.dir = dir
    save
    download_task.dir = dir
    download_task.save
  end

  def get_meta()
    doujinshi_meta.to_struct
  end

  def images
    DoujinshiImage.all(
      doujinshi_id: id
    ).map(&:filename)
  end

  after :create, :create_task

  def create_task
    DownloadTask.create(
      doujinshi_id: id,
      url: url,
      last_image: 0,
      status: :new
    )
  end
end