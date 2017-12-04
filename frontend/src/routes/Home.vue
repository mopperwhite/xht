<template lang="jade">
.container
  .row
    router-link.btn.col.s4(to="/download") Download
    router-link.btn.col.s4(to="/remote") Remote
    button.btn.col.s4(@click="random_choice") I'm Feeling Lucky
  .row
    downloading-list.col.s12
  .row
    doujinshi-list.col.s12(url="/api/query", @vkey="onkey")

</template>

<script>
import '../store'
import VKeys from '../vkeys'
import DoujinshiList from '../components/DoujinshiList.vue'
import DownloadingList from '../components/DownloadingList.vue'
export default {
  data () {
    return {
    }
  },
  methods: {
    random_choice(){
      let len = this.$store.state.doujinshi_list.length
      let index = Math.floor(Math.random() * len)
      this.$store.commit('move_selected_index', index)
      let id = this.$store.state.doujinshi_list[index].id
      this.$router.push(`/read/${id}`)
    },
    onkey({key}){
      console.log(key)
      if(key === VKeys.ROTATE){
        this.random_choice()
      }
    }
  },
  components: {
    DoujinshiList,
    DownloadingList
  }
}
</script>