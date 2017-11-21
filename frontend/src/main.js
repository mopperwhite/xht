import Vue from 'vue'

import VueResource from 'vue-resource'
import VueRouter from 'vue-router'

console.log('FUCK')
Vue.use(VueResource)
Vue.use(VueRouter)

import store from './store'
import router from './router'

import App from './App.vue'
import './event_init'

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
