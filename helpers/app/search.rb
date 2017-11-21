#!/usr/bin/env ruby
#encoding=utf-8
class WebViewer
  get '/api/query' do
    query = {
      Doujinshi.download_task.status => :finished,
      :unique => true
    }
    
    and_query = [] 
    qmeta = Doujinshi.doujinshi_meta
    
    if params[:range]
      from, to = params[:range].split('-').map(&:to_i)
      query.merge(offset: from, limit: to-from)
    end
    
    if params[:title]
      t_query = params[:title].split.map do |t|
        Doujinshi.all(qmeta.doujinshi_title.title.like => "%#{t}%")
      end
      and_query.push(t_query.reduce(&:&))
    end
    
    if params[:character]
      query[qmeta.doujinshi_character.name] = "%#{params[:character]}%"
    end
    
    if params[:characters]
      c_query = params[:characters].split('|').map do |t|
        Doujinshi.all(qmeta.doujinshi_character.name => t)
      end
      and_query.push(t_query.reduce(&:&))
    end
    
    if params[:tags]
      or_query = params[:tags].split('|').map do |t|
        Doujinshi.all(qmeta.doujinshi_tag.tag => t)
      end
      and_query.push(or_query.reduce(&:+))
    end
    
    [:author, :description, :group, :language, :category].each do |t|
      next if params[t].nil?
      query[qmeta.send(t).like] = "%#{params[t]}%"
    end

    ds = and_query.empty? ?
      Doujinshi.all(query) :
      Doujinshi.all(query) & and_query.reduce(&:+)
    ds.map do |d|
      d .doujinshi_meta
        .to_struct
        .to_h
        .merge(id: d.id)
    end.to_json
  end
end