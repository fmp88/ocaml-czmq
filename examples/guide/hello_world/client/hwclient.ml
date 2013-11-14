let _ = 
  print_endline "Connecting to hello world server...";
  let ctx = Czmq.Context.create () in
  let requester = Czmq.Socket.create ctx `Req in
  Czmq.Socket.connect requester "tcp://localhost:5555";

  for request_nbr = 0 to 9 do
    Printf.printf "Sending Hello %d...\n%!" request_nbr;
    Czmq.Str.send requester "Hello";
    let msg = Czmq.Str.recv requester in
    Printf.printf "Received %s %d\n%!" msg request_nbr;
  done;
