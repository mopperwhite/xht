const socket = new WebSocket('/io')
const event_map = {}

socket.onopen = () => {

}

socket.onmessage = (msg) => {
  console.log(msg)
  let {event, payload} = msg
  if(!event_map[event]) return;
  for(let f of event_map[event]){
    f(payload)
  }
}

socket.onerror = (err) => {
  console.warn("WS ERROR:", err)
}

socket.onclose = () => {
  console.warn("WS CLOSED")
}


export default {
  socket,
  emit(event, payload){
    if(!event_map[evnet]) return;
    socket.send({
      event,
      payload
    })
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
  }
}