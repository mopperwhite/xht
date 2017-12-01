const socket = new WebSocket(`ws://${location.host}/io`)
const event_map = {}

function emit_local_event(event, payload = null){
  if(!event_map[event]) return;
  for(let f of event_map[event]){
    f(payload)
  }
}

socket.onopen = () => {
  emit_local_event('connected')
}

socket.onmessage = (msg) => {
  // console.log(msg)
  let {event, payload} = JSON.parse(msg.data)
  emit_local_event(event, payload)
}

socket.onerror = (err) => {
  console.warn(`WS ERROR: ${err}`)
}

socket.onclose = () => {
  console.warn("WS CLOSED")
}


export default {
  socket,
  emit(event, payload = null){
    // if(!event_map[event]) return;
    socket.send(JSON.stringify({
      event,
      payload
    }))
  },
  on(event, func){
    if(!event_map[event]) event_map[event] = []
    event_map[event].push(func)
  },
  remove(event, func){
    if(!event_map[event]) return false;
    let i = event_map[event].indexOf(func)
    if(i==-1) return false;
    delete event_map[event][i]
    return true
  },
  close(){
    socket.close()
  }
}