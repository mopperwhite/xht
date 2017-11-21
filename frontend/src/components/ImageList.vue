<template lang="jade">
div
  .d-select-bar
    template(v-for="(f, i) in image_list")
      div(
        ref="select_list",
        :class="{selected: i == index}", 
        @click="select(i)")
        img(:src='image_url(i, [200, 300])')
  .d-select-bar-mask(@click="acquire_close")
    p CLOSE
</template>

<script>
import {get_title, shorten_title} from '../helpers'

export default {
  data () {
    return {
    }
  },
  watch: {
    index(val){
      if(this.$refs.select_list && this.$refs.select_list[this.index]){
        this.$refs.select_list[this.index].scrollIntoView()
      }
    }
  },
  props: ['image_list', 'id', 'index'],
  methods: {
    length(){
      return this.image_list.length
    },
    has_image(index){
      return  this.image_list && 
              this.image_list[index]
    },
    image_url(index, resize = null){
      let filename = this.image_list[index]
      let id = this.id
      if(resize){
        let [w, h] = resize
        return `/api/image?id=${id}&filename=${filename}&resize=${w}x${h}`
      }else{
        return `/api/image?id=${id}&filename=${filename}`
      }
    },
    acquire_close(){
      this.$emit('acquire_close')
    },
    select(index){
      this.$emit('selected', index)
    }
  },
  mounted(){
    if(this.$refs.select_list){
      this.$refs.select_list[this.index].scrollIntoView()
    }
  }
}
</script>