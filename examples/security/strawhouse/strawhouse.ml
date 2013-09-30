let () = 
  (* Create context *)
  let ctx = Czmq.Context.create () in

  (* Start an authentication engine for this context. This engine
     allows or denies incoming connections (talking to the libzmq
     core over a protocol called ZAP) *)
  let auth = Czmq.Auth.create ctx in
 
  (* Get some indication of what the authenticator is deciding *)
  Czmq.Auth.set_verbose auth true;

  (* Whitelist our address; any other address will be rejected *)
  Czmq.Auth.allow auth "127.0.0.1";

  (* Create and bind server socket *)
  let server = Czmq.Socket.create ctx `Push in
(*
  Czmq.Socket.set_zap_domain server "global";
*)
  Czmq.Socket.bind server "tcp://*:9000";

  (* Create and connect client socket *)
  let client = Czmq.Socket.create ctx `Pull in
  Czmq.Socket.connect client "tcp://127.0.0.1:9000";

  Czmq.Clock.sleep 1000;
  (* Send a single message from server to client *)
  Czmq.Str.send server "Hello";
  let message = Czmq.Str.recv client in
  print_endline message;
(*
  Czmq.Context.destroy ctx
*)
