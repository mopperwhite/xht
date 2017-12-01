<template lang="jade">
.container
  .row
    input.col.s6.m8.l10(v-model="download_link")
    button.col.s6.m4.l2.btn.btn-default(@click="download")
      | 下载
</template>

<script>
import {get_title, shorten_title} from '../helpers'

export default {
  data () {
    return {
      download_link: ''
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
  }
}
</script>