export function get_title(meta){
  if(meta.title){
    return meta.title
  }else{
    let keys = Object.keys(meta.title_lang)
    const langs = ['english', 'japanese']
    if(keys.length){
      for(let lang of langs){
        if(meta.title_lang[lang]){
          return meta.title_lang[lang]
        }
      }
      return meta.title_lang[keys[0]]
    }else{
      return '[No Title]'
    }
  }
}

export function shorten_title(title){
  return replace_all(title, /\[.+?\]|\(.+?\)|\{.+?\}/, '')
}

export function replace_all(str, substr, rep){
  while(str.match(substr)){
    str = str.replace(substr, rep)
  }
  return str
}