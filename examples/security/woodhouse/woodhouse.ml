let () = 
  (* Create context and start authentication engine *)
  let ctx = Zmq.Context.create () in
  let auth = Zmq.Auth.create ctx in
  Zmq.Auth.set_verbose auth true;
  Zmq.Auth.allow auth "127.0.0.1";

  (* Tell the authentication how to handle PLAIN requests *)
  Zmq.Auth.configure_plain auth "*" "passwords";

  (* Create and bind server socket *)
  let server = Zmq.Socket.create ctx `Push in
  Zmq.Socket.set_plain_server server 1;
  Zmq.Socket.bind server "tcp://*:9000";

  (* Create and connect client socket *)
  let client = Zmq.Socket.create ctx `Pull in
  Zmq.Socket.set_plain_username client "admin";
  Zmq.Socket.set_plain_password client "secret";
  Zmq.Socket.connect client "tcp://127.0.0.1:9000";

  Zmq.Clock.sleep 1000;
  (* Send a single message from server to client *)
  Zmq.Str.send server "Hello";
  let message = Zmq.Str.recv client in
  print_endline message;
(*
  Zmq.Context.destroy ctx
*)