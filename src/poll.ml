module Poll = struct

  type poll_t
  type t = poll_t Ctypes.structure Ctypes.Array.t

  type event = In | Out |InOut
  type item = (Socket.kind Socket.t * event) 

  let pollitem_t : poll_t structure typ = structure "zmq_pollitem_t"
  let socket = pollitem_t *:* (ptr void)
  let fd = pollitem_t *:* int
  let events = pollitem_t *:* int16_t
  let revents = pollitem_t *:* int16_t
  let () = seal pollitem_t

  let mask items =  
    let length = Array.length items in
    let poll_mask = Array.make pollitem_t length in
    let transform item = 
      let (socket_elt, event_elt) = match item with
      | (s, In) -> (s, 1)
      | (s, Out) -> (s, 2)
      | (s, InOut) -> (s, 42)
      in
      let pollitem = make pollitem_t in
      setf pollitem socket socket_elt;
      setf pollitem events event_elt;
      pollitem
    in
    for i=0 to length -1 do
      let tmp = transform (Array.get items i) in
      Array.set poll_mask i tmp;
    done;
    poll_mask
(*
  let poll ?timeout(t=0) mask = 
    let poll_stub = foreign "zmq_poll" (ptr pollitem @-> int @-> long @-> int) 
    in
    let length = Array.length mask in
    let retransform item = match item with
    | 
*)  
end

