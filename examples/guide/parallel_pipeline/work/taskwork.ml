let _ =
  let context = Czmq.Context.create () in
  let receiver = Czmq.Socket.create context `Pull in
  Czmq.Socket.connect receiver "tcp://localhost:5557";
  
  let sender = Czmq.Socket.create context `Push in
  Czmq.Socket.connect sender "tcp://localhost:5558";

  while true do
    let msg = Czmq.Str.recv receiver in
    Printf.printf "%s." msg;
    Czmq.Clock.sleep (String.length msg * 100);
    Czmq.Str.send sender "";
  done;
