let () = 
  (* Create context *)
  let ctx = Zmq.Context.create () in

  (* Create and bind server socket *)
  let server = Zmq.Socket.create ctx `Push in
  Zmq.Socket.bind server "tcp://*:9000";

  (* Create and connect client socket *)
  let client = Zmq.Socket.create ctx `Pull in
  Zmq.Socket.connect client "tcp://127.0.0.1:9000";

  Zmq.Clock.sleep 1000;
  (* Send a single message from server to client *)
  Zmq.Str.send server "Hello";
  let message = Zmq.Str.recv client in
  print_endline message;
(*
  Zmq.Context.destroy ctx
*)
