import keyboardJS from 'keyboardjs'
import VKeys from './vkeys'
import bus from './bus'
import io from './io'
import store from './store'

const key2evt = [
  [ VKeys.UP,     ['w', 'up'] ],
  [ VKeys.DOWN,   ['s', 'down'] ],
  [ VKeys.LEFT,   ['a', 'left'] ],
  [ VKeys.RIGHT,  ['d', 'right'] ],
  [ VKeys.ENTER,  ['enter', 'e'] ],
  [ VKeys.SWITCH, ['shift', 'z'] ],
  [ VKeys.QUIT,   ['esc', 'q', 'backspace'] ],
  [ VKeys.SELECT, ['f', 'l'] ],
  [ VKeys.REFRESH, ['r'] ],
  [ VKeys.ROTATE, ['c', '/'] ]
]

for(let [e, ks] of key2evt){
  for(let k of ks){
    keyboardJS.bind(k, event => {
      bus.$emit('pkey', {
        key: e,
        event
      })
      event.stopPropagation()
    })
  }
}

io.on('pong', payload => {
  console.log('pong')
})

io.on('key', key => {
  console.log(`remote: ${key}`)
  if(store.state.remote_control)
    bus.$emit('rkey', {
      key
    })
})

bus.$on('pkey', ({key, event}) => {
  bus.$emit('key', {key, event})
  if(store.state.remote_control)
    io.emit('key', key)
})

bus.$on('rkey', ({key}) => {
  bus.$emit('key', {key})
})

io.on('message', msg => {
  bus.$emit('message', msg)  
})

bus.$on('messgae', msg => {
  Materialize.toast(msg, 3000, 'message-toast')
  console.log("Message:", msg)
})

io.on('connected', ()=> {
  store.dispatch('init_io')
})