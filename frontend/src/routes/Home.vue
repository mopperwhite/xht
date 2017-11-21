<template lang="jade">
div
  .container
    .row
      input.col.s6.m8.l10(v-model="download_link")
      button.col.s6.m4.l2.btn.btn-default(@click="download")
        | 下载
    doujinshi-list
    

</template>

<script>
import '../store'
import DoujinshiList from '../components/DoujinshiList.vue'
export default {
  data () {
    return {
      download_link: '',
      doujinshi_list: []
    }
  },
  methods: {
    download(){
      this.$http.post('/api/download', {
        url: this.download_link
      }).then(res => {
        this.download_link = ''
      })
    }
  },
  beforeMount(){
    this.$store.dispatch('get_doujinshi_list', '/api/query')
  },
  components: {
    DoujinshiList
  }
}
</script>