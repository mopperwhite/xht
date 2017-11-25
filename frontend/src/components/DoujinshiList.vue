<template lang="jade">
.row(ref="row")
  template(v-for="(m, index) in $store.state.doujinshi_list")
    .doujinshi-card.col.s4.m3(
        @click="read(m.id, index)",
        :class='{"selected-card": index == $store.state.selected_index}',
        :title="get_title(m)",
        ref="card")
      .card-image
        img(:src="`/api/image?id=${m.id}&filename=${m.cover}&resize=800x800`")
      .card-content
        h6 {{get_title(m)}}
</template>

<script>
import '../store'
import {get_title, shorten_title} from '../helpers'
import bus from '../bus'
import VKeys from '../vkeys'

export default {
  data () {
    return {
      row_wrap: 1,
      col_wrap: 1,
    }
  },
  methods: {
    get_title(meta){
      return shorten_title(get_title(meta))
    },
    read(id, index=0){
      this.$store.commit('move_selected_index', index)
      this.$router.push(`/read/${id}`)
    },
    move_to_view_r(next_index){
      this.$store.commit('move_selected_index', this.$store.state.selected_index + next_index)
      let index = this.$store.state.selected_index
      if(this.$refs.card && this.$refs.card.length){
        this.$refs.card[index].scrollIntoView()
      }
    }
  },
  mounted(){
    // this.selected_index = 0
  },
  updated(){
    if(this.$refs.row && this.$refs.card){
      this.row_wrap = Math.round(this.$refs.row.clientWidth / this.$refs.card[0].clientWidth)
    }
  },
  created(){
    bus.$off('key')
    bus.$on('key', ({key, event}) => {
      switch(key){
        case VKeys.UP   : this.move_to_view_r(- this.row_wrap); break;
        case VKeys.DOWN : this.move_to_view_r(+ this.row_wrap); break;
        case VKeys.LEFT : this.move_to_view_r(- this.col_wrap); break;
        case VKeys.RIGHT: this.move_to_view_r(+ this.col_wrap); break;
        case VKeys.ENTER:
          let index = this.$store.state.selected_index
          let doujinshi =  this.$store.state.doujinshi_list[index]
          this.read(doujinshi.id, index); 
          break;
      }
      
    })
  }
}
</script>
