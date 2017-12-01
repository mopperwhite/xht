import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

import bus from './bus'

import api_actions from './actions/api'
import io_actions from './actions/io'


const store = new Vuex.Store({
  state: {
    selected_index: 0,
    doujinshi_list: [],
    image_list: [],
    doujinshi_info: null,
    pair_code: null
  },
  mutations: {
    clear_doujinshi_info(state){
      state.doujinshi_info = null
      state.image_list = []
    },
    set_pair_code(state, code){
      state.pair_code = code
    },
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
    message(_, msg){
      bus.$emit('message', msg)
    },
    ...api_actions,
    ...io_actions
  }
})

export default store;