#!/usr/bin/env ruby
#encoding=utf-8
class Doujinshi
  include DataMapper::Resource
  property  :id,   Serial
  property  :url,  String, length: 0..400
  property  :dir,  String, length: 0..400

  has 1, :doujinshi_meta
  has 1, :download_task
  has n, :doujinshi_image

  def create_meta(meta)
    dm = DoujinshiMeta.from_struct(meta, self)
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

  def isolate_meta()
    doujinshi_meta
      .to_struct
      .to_h
      .merge(
        :images => DoujinshiImages.all(doujinshi_id: id)
                                  .map(&:filename)
      )
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

  def Doujinshi.add(url, tag = nil)
    d = create(url: url)
    d.download_task.tag = tag
    d.download_task.save
    d
  end

  def Doujinshi.has_task?
    count(download_task.status.not => :finished) != 0
  end

  def Doujinshi.top_task
    first(download_task.status.not => :finished)
  end
end