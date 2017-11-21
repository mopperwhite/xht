import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import api_actions from './actions/api'

console.log(api_actions)

const store = new Vuex.Store({
  state: {
    selected_index: 0,
    doujinshi_list: [],
    image_list: [],
    doujinshi_info: null
  },
  mutations: {
    move_selected_index(state, next_index){
      if(next_index < 0){
        next_index = 0;
      }
      if(next_index >= state.doujinshi_list.length){
        next_index = state.doujinshi_list.length - 1;
      }
      state.selected_index = next_index
    },
    set_doujinshi_list(state, list){
      state.doujinshi_list = list
    },
    set_image_list(state, list){
      state.image_list = list
    },
    set_doujinshi_info(state, info){
      state.doujinshi_info = info
    }
  },
  actions: {
    ...api_actions
  }
})

export default store;