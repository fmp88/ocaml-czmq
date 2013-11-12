let _ = 
  let context = Czmq.Context.create () in
  let subscriber = Czmq.Socket.create context `Sub in
  Czmq.Socket.connect subscriber "tcp://localhost:5563";
  Czmq.Socket.set_subscribe subscriber "B";
  while true do
    match Czmq.Str.recvx subscriber with
    | addr::content::[] -> Printf.printf "[%s] %s\n%!" addr content;
    | _ -> ();
  done
