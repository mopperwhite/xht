import keyboardJS from 'keyboardjs'
import VKeys from './vkeys'
import bus from './bus'


const key2evt = [
  [ VKeys.UP,     ['w', 'up'] ],
  [ VKeys.DOWN,   ['s', 'down'] ],
  [ VKeys.LEFT,   ['a', 'left'] ],
  [ VKeys.RIGHT,  ['d', 'right'] ],
  [ VKeys.ENTER,  ['enter', 'e'] ],
  [ VKeys.SWITCH, ['shift', 'z'] ],
  [ VKeys.QUIT,   ['esc', 'q', 'backspace'] ],
  [ VKeys.SELECT, ['f', 'l'] ],
  [ VKeys.REFRESH, ['r'] ]
]

for(let [e, ks] of key2evt){
  for(let k of ks){
    keyboardJS.bind(k, event => {
      bus.$emit('key', {
        key: e,
        event
      })
      event.stopPropagation()
    })
  }
}