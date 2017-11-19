#!/usr/bin/env ruby
#encoding=utf-8
class DoujinshiMeta
  def tags
    DoujinshiTag.all(doujinshi_meta_id: id).map(&:tag)
  end

  def characters
    DoujinshiCharacter.all(doujinshi_meta_id: id).map(&:name)
  end

  def add_title(title, lang = nil)
    DoujinshiTitle.create(
      doujinshi_meta_id: id,
      title: title,
      has_lang: ! lang.nil?,
      lang: lang
    )
  end

  def title(lang = nil)
    lang.nil? ?
      DoujinshiTitle.first(
        doujinshi_meta_id: id,
        has_lang: false
      )&.title :
      DoujinshiTitle.first(
        doujinshi_meta_id: id,
        lang: lang
      )&.title
  end

  def title_lang
    DoujinshiTitle.all(
      doujinshi_meta_id: id,
      has_lang: true
    ).map do |t|
      [t.lang, t.title]
    end.to_h
  end

  def add_tags(ts)
    ts.each do |t|
      DoujinshiTag.create(
        doujinshi_meta_id: id,
        tag: t
      )
    end
  end

  def add_characters(cs)
    cs.each do |c|
      DoujinshiCharacter.create(
        doujinshi_meta_id: id,
        name: c
      )
    end
  end
end