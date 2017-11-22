<template lang="jade">
.container
  .row(v-if="$store.state.remote_control")
    label.col.s6 CODE: {{pair_code}}
    button.btn.col.s6(@click="unlink") UNLINK
  .row(v-else)
    label.col.s1 PAIR CODE:
    input.col.s9(v-model="pair_code")
    button.btn.col.s2(@click="pair") PAIR
    
  .row
    .col.s12
      table
        tr(v-for="row in remote_pad.CONTENT")
          template(v-for="cell in row")
            td.remote-ctrl-btn(
              v-if="cell",
              :class="cell.class",
              @click="type(cell.code)")
              i.material-icons.large {{ cell.icon }}
            td(v-else)
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
      remote_pad
    }
  },
  methods: {
    test(){
      console.log("ping")
      io.emit("ping", "test")
    },
    unlink(){
      this.$store.commit('set_remote_control', false)
      io.emit('leave')
    },
    pair(){
      this.$store.commit('set_remote_control', true)
      io.emit('pair', this.pair_code)
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