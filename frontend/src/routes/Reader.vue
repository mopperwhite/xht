<template lang="jade">
div
  button.d-act-btn.act-quit(@click="$router.back()")
    i.material-icons.large close
  button.d-act-btn.act-select(@click="selecting = true")
    i.material-icons.large list
  button.d-navi-btn.navi-priv(@click="set_index(image_index -1)")
    i.material-icons.large keyboard_arrow_left
  button.d-navi-btn.navi-next(@click="set_index(image_index +1)")
    i.material-icons.large keyboard_arrow_right
  image-list(
    v-if="selecting", 
    @selected="select_image",
    @acquire_close="close_select_list",
    :index.sync="selected_index",
    :id="$route.params.id",
    :image_list="$store.state.image_list")
  .container
    .row(v-if="$store.state.doujinshi_info")
      doujinshi-info(:meta="$store.state.doujinshi_info")
    .row
      .col.s12.doujinshi-image-container
        img(
          @click="set_index(image_index +1)",
          ref="image",
          :class='get_read_mode()',
          :src="image_url(image_index)", 
          v-if="has_image(image_index)")
</template>

<script>
import bus from '../bus'
import VKeys from '../vkeys'
import {get_title, shorten_title} from '../helpers'

import ImageList from '../components/ImageList.vue'
import DoujinshiInfo from '../components/DoujinshiInfo.vue'

const READ_MODE = [
  'full',
  'mid',
  'whole'
]

const MAX_SPEED = 40
const SPEED_STEP= 2
const SPEED_EXPIRE = 100

export default {
  components: {
    ImageList,
    DoujinshiInfo
  },
  data () {
    return {
      image_index: 0,
      read_mode: 0,
      scroll_speed: 0,
      speed_update_time: 0,
      selecting: false,
      selected_index: 0
    }
  },
  methods: {
    has_image(index){
      return  this.$store.state.image_list && 
              this.$store.state.image_list[index]
    },
    image_url(index, resize = null){
      let filename = this.$store.state.image_list[index]
      let id = this.$route.params.id
      if(resize){
        let [w, h] = resize
        return `/api/image?id=${id}&filename=${filename}&resize=${w}x${h}`
      }else{
        return `/api/image?id=${id}&filename=${filename}`
      }
    },
    length(){
      return this.$store.state.image_list.length
    },
    switch_mode(){
      this.read_mode = (this.read_mode + 1) % READ_MODE.length
      if(this.$refs.image){
        this.$refs.image.scrollIntoView()
      }
    },
    get_read_mode(){
      return `img-${READ_MODE[this.read_mode]}-size`
    },
    set_index(index){
      if(index < 0) index = 0
      if(index >= this.length()) index = this.length()-1
      this.image_index = index
      if(this.$refs.image){
        this.$refs.image.scrollIntoView()
      }
    },
    start_scroll(speed){
      let el = this.$root.$el
      el.scrollTop += speed
    },
    open_select_list(){
      this.selected_index = this.image_index
      this.selecting = true
    },
    close_select_list(){
      console.log("INGORED")
      this.selecting = false
    },
    select_image(index){
      this.set_index(index)
      this.selecting = false
    }
  },
  beforeMount(){
    this.$store.dispatch('get_image_list', this.$route.params.id)
    this.$store.dispatch('get_doujinshi_info', this.$route.params.id)
  },
  created(){
    bus.$off('key')
    bus.$on('key', ({key, event}) => {
      if(this.selecting){
        switch(key){
          case VKeys.UP:      this.selected_index = Math.max(0, this.selected_index-1); break;
          case VKeys.DOWN:    this.selected_index = Math.min(this.length()-1, this.selected_index+1); break;
          case VKeys.SELECT:
          case VKeys.ENTER:   this.select_image(this.selected_index); break;
        }
      }else{
        switch(key){
          case VKeys.QUIT:
            this.$router.back();
            break;
          case VKeys.LEFT:    this.set_index(this.image_index-1); break;
          case VKeys.RIGHT:   this.set_index(this.image_index+1); break;
          case VKeys.UP:      this.start_scroll(-MAX_SPEED); break;
          case VKeys.DOWN:    this.start_scroll(+MAX_SPEED); break;
          case VKeys.SELECT:  this.open_select_list(); break;
          case VKeys.SWITCH:  this.switch_mode(); break;
        }
      }
    })
  }
}
</script>