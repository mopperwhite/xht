import axios from 'axios'

axios.interceptors.response.use(
  (response) => {
    return response.data;
  }, 
  (error) => {
    if (error.response.status === 401) {
        console.log("ERROR!", error.response.body)
    }
    return Promise.reject(error.response);
  }
);

function get_doujinshi_list({commit}, url){
  axios.get(url)
  .then(list => {
    commit('set_doujinshi_list', list)
  })
}

function get_image_list({commit}, id){
  axios.get(`/api/images/${id}`)
  .then(list => {
    commit('set_image_list', list)
  })
}

function get_doujinshi_info({commit}, id){
  axios.get(`/api/info/${id}`)
  .then(info => {
    commit('set_doujinshi_info', info)
  })
}

export default {
  get_doujinshi_list,
  get_doujinshi_info,
  get_image_list
}