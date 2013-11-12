let _ =
  let context = Czmq.Context.create () in
  
  (* Socket to talk to clients *)
  let publisher = Czmq.Socket.create context `Pub in
  Czmq.Socket.bind publisher "tcp://*:5561";

  (* Socket to receive signals *)
  let syncservice = Czmq.Socket.create context `Rep in
  Czmq.Socket.bind syncservice "tcp://*:5562";

  (* Get synchronization from subscribers *)
  print_endline "Waiting for subscribers";
  let subscribers = ref 0 in
  while !subscribers < 10 do
    (*  wait for synchronization request *)
    let msg = Czmq.Str.recv syncservice in
    (* send synchronization reply *)
    Czmq.Str.send syncservice "";
    subscribers := !subscribers + 1;
  done;

  (* Now broadcast exactly 1M updates followed by END *)
  print_endline "Broadcasting message";
  for update_nbr = 0 to 999999 do
    Czmq.Str.send publisher "Rhabarb";
  done;
  
  print_endline "send: END";
  Czmq.Str.send publisher "END";
