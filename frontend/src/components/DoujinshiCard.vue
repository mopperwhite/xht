<template lang="jade">
.doujinshi-card(
    :class='{"selected-card": selected, "downloading-card": !finished}',
    :title="get_title(doujinshi)",
    ref="card",
    @click="$emit('click', $event)"
    )
  .card-image
    img(:src="`/api/image?id=${doujinshi.id}&filename=${doujinshi.cover}&resize=800x800`")
    template(v-if="!finished")
      text-center
        i.image-icon.material-icons.small file_download
      a.btn-floating.halfway-fab(@click="delete_doujinshi")
        i.material-icons.large close
       
  .card-content
    h6 {{get_title(doujinshi)}}
</template>

<script>
import {get_title, shorten_title} from '../helpers'
import TextCenter from './TextCenter.vue'
export default {
  data () {
    return {
    }
  },
  components: {
    TextCenter
  },
  computed: {
    clientWidth(){
      return this.$refs.card && this.$refs.card.clientWidth
    }
  },
  props: {
    doujinshi:{
      type: Object,
      required: true
    },
    selected: {
      type: Boolean,
      default: false
    }, 
    finished: {
      type: Boolean,
      default: true
    }
  },
  methods: {
    get_title(meta){
      return shorten_title(get_title(meta))
    },
    scrollIntoView(){
      this.$refs.card.scrollIntoView()
    },
    delete_doujinshi(){
      console.log("DELETE", this.doujinshi.id)
    }
  }
}
</script>