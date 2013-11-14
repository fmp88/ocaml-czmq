let _ = 
  print_endline "Connecting to hello world server...";
  let ctx = Czmq.Context.create () in
  let responder = Czmq.Socket.create ctx `Rep in
  Czmq.Socket.bind responder "tcp://*:5555";

  while true do 
    let buffer = Czmq.Str.recv responder in
    print_endline "Received Hello";
    Czmq.Clock.sleep 1000;
    Czmq.Str.send responder "World";
  done;
