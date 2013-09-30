let () = 
  (* Create context *)
  let ctx = Zmq.Context.create () in

  (* Start an authentication engine for this context. This engine
     allows or denies incoming connections (talking to the libzmq
     core over a protocol called ZAP) *)
  let auth = Zmq.Auth.create ctx in
 
  (* Get some indication of what the authenticator is deciding *)
  Zmq.Auth.set_verbose auth true;

  (* Whitelist our address; any other address will be rejected *)
  Zmq.Auth.allow auth "127.0.0.1";

  (* Create and bind server socket *)
  let server = Zmq.Socket.create ctx `Push in
(*
  Zmq.Socket.set_zap_domain server "global";
*)
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
