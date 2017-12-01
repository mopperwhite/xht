<template lang="jade">
.doujinshi-info.container
  template(v-for="(t, i) in titles")
      template(v-if="i==0")
        .row
          h1.col.s12 {{t}}
      template(v-else)
        .row
          h2.col.s12 {{t}}
  .row
    div.doujinshi-info-tags.col.s12
      .row
        .col.s2 Author: 
        .col.s10 {{meta.author}}
      .row 
        .col.s2 Language: 
        .col.s10 {{meta.language}}
      .row 
        .col.s2 Tags:
        .col.s10
          .chip(v-for="t in meta.tags")
            | {{t}}

</template>

<script>
import {get_title} from '../helpers'

export default {
  data () {
    return {
      titles: []
    }
  },
  props: ['meta'],
  beforeMount(){
    if(this.meta.title){
      this.titles.push(this.meta.title)
    }
    for(let t of Object.values(this.meta.title_lang)){
      if(t)
        this.titles.push(t)
    }
  }
}
</script>