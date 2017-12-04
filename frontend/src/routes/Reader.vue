<template lang="jade">
div
  image-list(
    v-if="selecting", 
    @selected="select_image",
    @acquire_close="close_select_list",
    :index.sync="selected_index",
    :id="$route.params.id",
    :image_list="$store.state.image_list")
  button.d-act-btn.act-quit(@click="$router.back()")
    i.material-icons.large close
  button.d-act-btn.act-select(@click="selecting = true")
    i.material-icons.large list
  button.d-act-btn.act-zoom(@click="switch_mode")
    i.material-icons.large zoom_out
  button.d-act-btn.act-rotate(
    @click="rotate",
    @dblclick="hold_rotation = !hold_rotation; rotate(); rotate();",
    :class="{'act-hold': hold_rotation}")
    i.material-icons rotate_right
  button.d-navi-btn.navi-priv(@click="set_index(image_index -1)")
    i.material-icons keyboard_arrow_left
  button.d-navi-btn.navi-next(@click="set_index(image_index +1)")
    i.material-icons keyboard_arrow_right
  template(v-if="read_mode != 3")
    .container
      .row(v-if="$store.state.doujinshi_info")
        doujinshi-info.col.s12(:meta="$store.state.doujinshi_info")
      .row
        .col.s12.doujinshi-image-container
          img.reader-image(
            @click="set_index(image_index +1)",
            ref="image",
            :class='get_read_mode()',
            :src="image_url(image_index)", 
            v-if="has_image(image_index)")
      form.row(action="#")
        .col.s6.switch
          label
            | ORIGINAL
            input(type="checkbox", v-model="enhance")
            span.lever
            | ENHANCED
  template(v-else)
    dive-in(
      ref="divein",
      :rotate="rotate_ang",
      :src="image_url(image_index)",
      v-if="has_image(image_index)")
</template>

<script>
import bus from '../bus'
import VKeys from '../vkeys'
import {get_title, shorten_title} from '../helpers'

import ImageList from '../components/ImageList.vue'
import DoujinshiInfo from '../components/DoujinshiInfo.vue'
import DiveIn from '../components/DiveIn.vue'

const READ_MODE = [
  'full',
  'mid',
  'whole',
  'dive'
]

const MAX_SPEED = 40
const SPEED_STEP= 2
const SPEED_EXPIRE = 100

export default {
  components: {
    ImageList,
    DoujinshiInfo,
    DiveIn
  },
  data () {
    return {
      image_index: 0,
      read_mode: 0,
      scroll_speed: 0,
      speed_update_time: 0,
      selecting: false,
      selected_index: 0,
      rotate_ang: 0,
      hold_rotation: false,
      enhance: false,
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
      let url = `/api/image?id=${id}&filename=${filename}`
      if(resize){
        let [w, h] = resize
        url += `&resize=${w}x${h}`
      }
      if(this.enhance){
        url += '&enhance=normalize'
      }
      return url
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
      return [`rotate-${this.rotate_ang}deg`, `img-${READ_MODE[this.read_mode]}-size`]
    },
    set_index(index){
      if(index < 0) index = 0
      if(index >= this.length()) index = this.length()-1
      this.image_index = index
      if(!this.hold_rotation){
        this.rotate_ang = 0
      }
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
    },
    move_distance(){
      return parseInt(window.innerHeight * 0.3)
    },
    load(){
      this.$store.dispatch('get_doujinshi_info', this.$route.params.id)
    },
    rotate(){
      this.rotate_ang += 90
      this.rotate_ang %= 360
    }
  },
  mounted(){
    this.load()
  },
  created(){
    this.image_index = this.$route.params.page || 0
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
          case VKeys.QUIT: this.$router.back(); break;
          case VKeys.SWITCH:  this.switch_mode(); break;
          case VKeys.REFRESH:  this.load(); break;
          case VKeys.ROTATE:  this.rotate(); break;
          case VKeys.SELECT:  this.open_select_list(); break;
          case VKeys.ENTER:   this.set_index(this.image_index+1); break;
          default:
            if(this.read_mode == 3){ // dive in
              let di = this.$refs.divein
              if(!di) break;
              switch(key){
                case VKeys.LEFT:
                case VKeys.RIGHT:
                case VKeys.UP:
                case VKeys.DOWN:
                  di.move(key);
                  break;
              }
            }else{
              switch(key){
                case VKeys.LEFT:    this.set_index(this.image_index-1); break;
                case VKeys.RIGHT:   this.set_index(this.image_index+1); break;
                case VKeys.UP:      this.start_scroll(-this.move_distance()); break;
                case VKeys.DOWN:    this.start_scroll(+this.move_distance()); break;
              }
            }
        }
      }
    })
  }
}
</script>