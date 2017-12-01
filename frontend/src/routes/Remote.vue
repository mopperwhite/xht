<template lang="jade">
.container
  .row(v-if="$store.state.pair_code")
    label.col.s6 CODE: {{$store.state.pair_code}}
    button.btn.col.s6(@click="unlink") UNLINK
  .row(v-else)
    label.col.s1 PAIR CODE:
    input.col.s9(v-model="pair_code")
    button.btn.col.s2(@click="pair") PAIR
  
  .row
    button.btn.btn-default.col.s4(@click='panel_mode="left"') LEFT
    button.btn.btn-default.col.s4(@click='panel_mode="center"') CENTER
    button.btn.btn-default.col.s4(@click='panel_mode="right"') RIGHT
  .row
    .col.s4(v-if='panel_mode=="right"')
    .col(:class='{s12: panel_mode=="center", s8: panel_mode!="center"}')
      table
        tr(v-for="row in remote_pad.CONTENT")
          template(v-for="cell in row")
            td.remote-ctrl-btn(
              v-if="cell",
              :class="cell.class",
              @click="type(cell.code)")
              i.material-icons.large {{ cell.icon }}
            td(v-else)
    .col.s4(v-if='panel_mode=="left"')
  .row
    button.btn.col.s12(
      @click="$router.push('/')"
    ) BACK TO HOMEPAGE

</template>

<script>
import {get_title, shorten_title} from '../helpers'
import io from '../io'
import remote_pad from '../helpers/remote_pad'
import bus from '../bus'
export default {
  data () {
    return {
      pair_code: '',
      remote_pad,
      panel_mode: 'center'
    }
  },
  methods: {
    test(){
      console.log("ping")
      io.emit("ping", "test")
    },
    unlink(){
      this.pair_code = this.$store.state.pair_code
      this.$store.dispatch('leave_room')
    },
    pair(){
      this.$store.dispatch('join_room', this.pair_code)
    },
    type(code){
      console.log(code)
      io.emit('key', code)
    }
  },
  beforeMount(){
    bus.$off('key')
  }
}
</script>