<template lang="jade">
.container
  .row(ref="row")
    template(v-for="(m, index) in $store.state.downloading_list")
      doujinshi-card.col.s4.m3(
        :doujinshi="m",
        :finished="false"
      )
</template>

<script>
import '../store'
import {get_title, shorten_title} from '../helpers'
import bus from '../bus'
import VKeys from '../vkeys'
import DoujinshiCard from './DoujinshiCard.vue'

export default {
  data () {
    return {
      row_wrap: 1,
      col_wrap: 1,
    }
  },
  props: ['url'],
  watch: {
    url(){
      this.reload()
    }
  },
  components: {
    DoujinshiCard
  },
  created(){
    this.$store.dispatch('get_downloading_list')
  }
}
</script>
