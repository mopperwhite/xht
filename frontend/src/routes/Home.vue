<template lang="jade">
.container
  .row
    router-link.btn.col.s4(to="/download") Download
    router-link.btn.col.s4(to="/remote") Remote
  .row
    doujinshi-list.col.s12(url="/api/query")

</template>

<script>
import '../store'
import DoujinshiList from '../components/DoujinshiList.vue'
export default {
  data () {
    return {
    }
  },
  components: {
    DoujinshiList
  }
}
</script>