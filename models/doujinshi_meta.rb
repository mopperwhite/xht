#!/usr/bin/env ruby
#encoding=utf-8
require './helpers/models/doujinshi_meta'
require './models/doujinshi_tags'
require './models/doujinshi_characters'
require './models/doujinshi_title'

class DoujinshiMeta
  include DataMapper::Resource
  property :id,         Serial
  property :author,     String
  property :group,      String
  property :language,   String
  property :category,   String
  property :description,Text
  property :source,     String
  property :uid,        String
  property :cover,      String
  
  belongs_to  :doujinshi
  has n, :doujinshi_tag, :constraint => :destroy
  has n, :doujinshi_character, :constraint => :destroy
  has n, :doujinshi_title, :constraint => :destroy

  def to_struct
    MetaInfo.new(
      title,
      title_lang, 
      author,
      group,
      characters,
      language, 
      category, 
      tags,
      description, 
      source,
      uid,
      cover
    )
  end

  # before :destroy do
  #   doujinshi_tag.destroy
  #   doujinshi_character.destroy
  #   doujinshi_title.destroy
  # end

  def DoujinshiMeta.from_struct(meta, doujinshi)
    h = meta.to_h
    title = h.delete :title
    title_lang = h.delete :title_lang
    tags = h.delete :tags
    characters = h.delete :characters

    m = create(h.merge(doujinshi_id: doujinshi.id))
    m.add_tags tags
    m.add_characters characters
    m.add_title(title) unless title.nil?
    title_lang.each_pair do |lang, t|
      m.add_title(t, lang) unless t.nil?
    end
    m
  end
end