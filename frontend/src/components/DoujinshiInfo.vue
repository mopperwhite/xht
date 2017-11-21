<template lang="jade">
.doujinshi-info
  template(v-for="(t, i) in titles")
      template(v-if="i==0")
        h1.col.s12 {{t}}
      template(v-else)
        h2.col.s12 {{t}}
  table
    tr
      td Author:
      td 
        span.chip {{meta.author}}
    tr
      td Language:
      td {{meta.language}}
    tr
      td Tags:
      td
        span.chip(v-for="t in meta.tags")
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