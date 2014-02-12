let _ = 
  print_endline "Connecting to hello world server...";
  let ctx = Czmq.Context.create () in
  let responder = Czmq.Socket.create ctx `Rep in
  Czmq.Socket.bind responder "tcp://*:5555";

  while true do 
    let buffer = Czmq.Msg.recv responder in  
    let frame = Czmq.Msg.pop buffer in
    match frame with
    | None -> print_endline "None";
    | Some x -> print_endline (Czmq.Frame.data x);
    Printf.printf "Received Hello%!\n";
    Czmq.Clock.sleep 1000;
    let frame1 = Czmq.Frame.create "World" in
    let frame2 = Czmq.Frame.create "World_2" in
    let msg = Czmq.Msg.create () in
    Czmq.Msg.append msg frame1;
    Czmq.Msg.append msg frame2;
    Czmq.Msg.send msg responder;
  done;
