let () = 
  (* Create context and start authentication engine *)
  let ctx = Czmq.Context.create () in
  let auth = Czmq.Auth.create ctx in
  Czmq.Auth.set_verbose auth true;
  Czmq.Auth.allow auth "127.0.0.1";

  (* Tell the authentication how to handle PLAIN requests *)
  Czmq.Auth.configure_plain auth "*" "passwords";

  (* Create and bind server socket *)
  let server = Czmq.Socket.create ctx `Push in
  Czmq.Socket.set_plain_server server 1;
  Czmq.Socket.bind server "tcp://*:9000";

  (* Create and connect client socket *)
  let client = Czmq.Socket.create ctx `Pull in
  Czmq.Socket.set_plain_username client "admin";
  Czmq.Socket.set_plain_password client "secret";
  Czmq.Socket.connect client "tcp://127.0.0.1:9000";

  Czmq.Clock.sleep 1000;
  (* Send a single message from server to client *)
  Czmq.Str.send server "Hello";
  let message = Czmq.Str.recv client in
  print_endline message;
(*
  Czmq.Context.destroy ctx
*)
