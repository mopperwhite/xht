<template lang="jade">
div.container
  .row
    .col.s12
      h1 Authorization
  .row
    .col.s12.input-field
      input#usernameI(v-model="username", type="text", @keyup.enter="$refs.pwd_input.focus()")
      label(for="usernameI") Username
  .row
    .col.s12.input-field
      input#passwordI(ref="pwd_input",v-model="password", type="password", @keyup.enter="login")
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