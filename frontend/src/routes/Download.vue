<template lang="jade">
.container
  .row
    input.col.s6.m8.l10(v-model="download_link")
    button.col.s6.m4.l2.btn.btn-default(@click="download")
      | 下载
  .row
    downloading-list.col.s12
  .row.download-message
    .col.s12
      pre(v-for="m in d_message") {{m}} 
</template>

<script>
import {get_title, shorten_title} from '../helpers'
import bus from '../bus'
import io from '../io'
import DownloadingList from '../components/DownloadingList.vue'

export default {
  data () {
    return {
      download_link: '',
      d_message: [],
      buffer_size: 500
    }
  },
  components: {
    DownloadingList
  },
  methods: {
    download(){
      this.$http.post('/api/download', {
        url: this.download_link
      }).then(res => {
        if(res.accepted)
          this.download_link = ''
        else
          this.$store.dispatch('message', 'Task Exists.')
      })
    }
  },
  // beforeRouteLeave(){
  //   bus.$off('download_message')
  //   console.log("SHIT")
  // },
  // afterRouteEnter(){
  //   console.log("FUCK")
  //   bus.$on('download_message', msg => {
  //     console.log("SHIT", msg)
  //     this.$store.dispatch('message', msg)
  //     // this.d_message = msg + "\n" + this.d_message
  //   })
  // }
  created(){
    io.on('download_message', msg => {
      console.log('D MSG:', msg)
      this.d_message.unshift(msg)
      if(this.d_message.length > this.buffer_size){
        this.d_message.pop()
      }
    })
  }
}
</script>