<template lang="jade">
#app
  router-view(v-if="$store.state.accessable")
  login(v-else)
</template>

<script>
import Login from './routes/Login.vue' 
export default {
  name: 'app',
  components: {
    Login
  }
}
</script>

<style lang="scss" scoped>

</style>
