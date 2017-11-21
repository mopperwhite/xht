import VueRouter from 'vue-router'

import Home     from './routes/Home.vue'
import Search   from './routes/Search.vue'
import Settings from './routes/Settings.vue'
import Download from './routes/Download.vue'
import Reader   from './routes/Reader.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/search', component: Search },
  { path: '/settings', component: Settings },
  { path: '/download', component: Download },
  { path: '/read/:id', component: Reader }
]

export default new VueRouter({
  routes
})