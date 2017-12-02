<template lang="jade">
div.container
  .row
    .col.s12.input-field
      input#usernameI(v-model="username")
      label(for="usernameI") Username
    .col.s12.input-field
      input#passwordI(v-model="password", type="password")
      label(for="passwordI") Password
    button.col.s12.btn(@click="login") Login
</template>

<script>
import {get_title, shorten_title} from '../helpers'

export default {
  data () {
    return {
      username: '',
      password: ''
    }
  },
  methods: {
    login(){
      this.$store.dispatch('login', {
        username: this.username,
        password: this.password
      })
    }
  },
  beforeMount(){
  }
}
</script>