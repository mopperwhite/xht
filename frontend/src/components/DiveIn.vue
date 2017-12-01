<template lang="jade">
div(ref="self")
  img.reader-image(
    @mousedown="start_drawing",
    @mouseup="stop_drawing",
    @mousemove="drawing",
    @touchstart="start_drawing",
    @touchend="stop_drawing",
    @touchmove="drawing",
    :src="src", 
    ref="image", 
    :class="`rotate-${rotate}deg img-dive`",
    :id="image_id",
  )
</template>

<script>
import {get_title} from '../helpers'
import VKeys from '../vkeys'

const STEP_LEN = 10

const DX = {
  [VKeys.UP]:   0,
  [VKeys.DOWN]: 0,
  [VKeys.LEFT]: -STEP_LEN,
  [VKeys.RIGHT]:+STEP_LEN,
}

const DY = {
  [VKeys.UP]:   -1,
  [VKeys.DOWN]: +1,
  [VKeys.LEFT]: 0,
  [VKeys.RIGHT]:0,
}

export default {
  data () {
    return {
      drawing_started: false,
      last_pos: null,
      offset_x: 0,
      offset_y: 0,
      image_id: `divein_image_${Math.ceil( Math.random() * (1<<30) )}`,
    }
  },
  props: ['src', 'rotate'],
  watch: {
    src(news, olds){
      this.offset_x=
      this.offset_y= 0
      this.move_img(0, 0)
    }
  },
  beforeDestory(){
    console.log(233)
  },
  methods: {
    move_img(x, y){
      let img = document.getElementById(this.image_id)
      img.style.left =  -parseInt(x) + 'px'
      img.style.top =   -parseInt(y) + 'px'
    },
    dmove([dx, dy]){
      [this.offset_x, this.offset_y] = this.pos_valid([
        this.offset_x + dx,
        this.offset_y + dy
      ])
      this.move_img(this.offset_x, this.offset_y)
    },
    move(vk){
      let w = this.$refs.image.clientWidth
      let h = this.$refs.image.clientHeight
      let sw = document.body.clientWidth
      let sh = document.body.clientHeight
      let d = Math.min(sw*0.3, sh*0.3) 
      let dx = DX[vk] * d
      let dy = DY[vk] * d
      this.dmove([+dx, +dy])
    },
    pos_valid([x, y]){
      let w = this.$refs.image.clientWidth
      let h = this.$refs.image.clientHeight
      let sw = document.body.clientWidth
      let sh = document.body.clientHeight
      let max_x = w - sw
      let max_y = h - sh
      x = Math.min(Math.max(0, x), max_x)
      y = Math.min(Math.max(0, y), max_y)
      return [x, y]
    },
    get_event_pos(evt){
      if(window.TouchEvent && (evt instanceof window.TouchEvent)){
        let t = evt.targetTouches[0]
        return [t.screenX, t.screenY]
      }else if(evt.screenX && evt.screenY){
        return [evt.screenX, evt.screenY]
      }else{
        console.warn(evt)
        throw "Unknown Event"
      }
    },
    start_drawing(evt){
      this.drawing_started = true
      let [x, y] = this.get_event_pos(evt)
      this.last_pos = [x, y]
      return false
    },
    stop_drawing(evt){
      this.drawing_started = false
    },
    drawing(evt){
      if(!this.drawing_started) return;
      let [x, y] = this.get_event_pos(evt)
      let [lx, ly] = this.last_pos
      let dx = x - lx
      let dy = y - ly
      this.last_pos = [x, y]
      this.dmove([-dx, -dy])
    }
  }
}
</script>