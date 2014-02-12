let _ = 
  print_endline "Connecting to hello world server...";
  let ctx = Czmq.Context.create () in
  let requester = Czmq.Socket.create ctx `Req in
  Czmq.Socket.connect requester "tcp://localhost:5555";

  Printf.printf "Sending Hello %d...\n%!" 1;
  let msg  = Czmq.Msg.create () in
  let frame = Czmq.Frame.create (Printf.sprintf "Hello first %d" 1) in
  Czmq.Msg.append msg frame;
  Czmq.Msg.send msg requester;
  let a = Czmq.Msg.recv requester in
  let cond = ref true in
  while !cond do
    let frame = Czmq.Msg.pop a in
    match frame with 
    | None -> cond := false
    | Some x -> print_endline (Czmq.Frame.data x)
  done;
