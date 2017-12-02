import axios from 'axios'
import store from '../store'
import io from '../io'

axios.interceptors.response.use(
  (response) => {
    return response.data;
  }, 
  (error) => {
    if (error.response.status === 401) {
        let msg = error.response.body
        console.log("ERROR!", msg)
        store.dispatch('message', `Error: ${msg}`)
    }
    return Promise.reject(error.response);
  }
);

function access_ws({commit}){
  axios.get('/api/accesscode').then(({authorization, accesscode}) => {
    if(authorization){
      if(accesscode){
        console.log(accesscode)
        io.emit('access', accesscode)
      }else{
        store.dispatch('message', "Please Login.")
      }
    }else{
      store.dispatch('init_io')
    }
  })
}

function login({commit, dispatch}, {username, password}){
  axios.post('/api/login', {
    username, password
  }).then(res => {
    dispatch('access_ws')
  })
}

function get_doujinshi_list({commit}, url){
  axios.get(url)
  .then(list => {
    commit('set_doujinshi_list', list)
  })
}

function get_doujinshi_info({commit}, id){
  commit('clear_doujinshi_info')
  axios.get(`/api/images/${id}`)
  .then(list => {
    commit('set_image_list', list)
  })
  axios.get(`/api/info/${id}`)
  .then(info => {
    commit('set_doujinshi_info', info)
  })
}

export default {
  get_doujinshi_list,
  get_doujinshi_info,
  access_ws,
  login
}