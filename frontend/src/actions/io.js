import io from '../io'

function init_io({commit, dispatch}){
  dispatch('init_remote_control')
}

function init_remote_control({commit, dispatch}){
  if(localStorage['io.room.pair_code']){
    dispatch('join_room', localStorage['io.room.pair_code'])
  }
}

function join_room({commit}, code){
  io.emit('pair', code)
  commit('set_pair_code', code)
  localStorage['io.room.pair_code'] = code
}

function leave_room({commit}){
  io.emit('leave')
  commit('set_pair_code', null)
  delete localStorage['io.room.pair_code']
}

export default {
  init_io,
  init_remote_control,
  join_room,
  leave_room
}