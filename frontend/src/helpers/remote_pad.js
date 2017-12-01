import VKeys from '../vkeys'

const REMOTE_PAD = [
  "XN.",
  ".UG",
  "LAR",
  "ZDC",
]

const KEY_MAP = {
  U: VKeys.UP,
  D: VKeys.DOWN,
  L: VKeys.LEFT,
  R: VKeys.RIGHT,
  A: VKeys.ENTER,
  X: VKeys.QUIT,
  G: VKeys.SELECT,
  N: VKeys.RELOAD,
  Z: VKeys.SWITCH,
  C: VKeys.ROTATE,
}

const ICON = {
  [VKeys.UP]:     'keyboard_arrow_up',
  [VKeys.DOWN]:   'keyboard_arrow_down',
  [VKeys.LEFT]:   'keyboard_arrow_left',
  [VKeys.RIGHT]:  'keyboard_arrow_right',
  [VKeys.ENTER]:  'check',
  [VKeys.QUIT]:   'close',
  [VKeys.SELECT]: 'view_list',
  [VKeys.RELOAD]: 'refresh',
  [VKeys.SWITCH]: 'zoom_out',
  [VKeys.ROTATE]: 'rotate_right',
}

const CLASS = {
  [VKeys.UP]:     '',
  [VKeys.DOWN]:   '',
  [VKeys.LEFT]:   '',
  [VKeys.RIGHT]:  '',
  [VKeys.ENTER]:  '',
  [VKeys.QUIT]:   '',
  [VKeys.SELECT]: '',
  [VKeys.RELOAD]: '',
  [VKeys.SWITCH]: '',
}

const WIDTH  = 3
const HEIGHT = 4

export default {
  WIDTH,
  HEIGHT,
  CONTENT: REMOTE_PAD.map(r => {
    return r.split('').map(c => {
      if(c != '.'){
        let code = KEY_MAP[c]
        return {
          code,
          class: CLASS[code],
          icon:   ICON[code]
        }
      }else{
        return null
      }
    })
  })
}