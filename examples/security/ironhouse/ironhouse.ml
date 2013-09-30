(*  The Ironhouse Pattern
  
    Security doesn't get any stronger than this. An attacker is going to
    have to break into your systems to see data before/after encryption. *)

let () = 
   (*  Create context and start authentication engine *)
   let ctx = Zmq.Context.create () in
   let auth = Zmq.Auth.create ctx in
   Zmq.Auth.set_verbose auth true;
   Zmq.Auth.allow auth "127.0.0.1";
   
   (*  Tell authenticator to use the certificate store in .curve *)
   Zmq.Auth.configure_curve auth "*" ".curve";
   
   (*  We'll generate a new client certificate and save the public part
       in the certificate store (in practice this would be done by hand
       or some out-of-band process). *)
   let client_cert = Zmq.Cert.create () in
   Zmq.Sys.dir_create (".curve");
   Zmq.Cert.set_meta client_cert "name" "Client test certificate";
(*
   Zmq.Cert.save_public client_cert ".curve/testcert.pub";
*)
   
   (*  Prepare the server certificate as we did in Stonehouse *)
   let server_cert = Zmq.Cert.create () in
   let server_key = Zmq.Cert.public_txt server_cert in
   
   (*  Create and bind server socket *)
   let server = Zmq.Socket.create ctx `Push in
   Zmq.Cert.apply server_cert server;
   Zmq.Socket.set_curve_server server true;
   Zmq.Socket.bind server "tcp://*:9000";

   (*  Create and connect client socket *)
   let client = Zmq.Socket.create ctx `Pull in
   Zmq.Cert.apply client_cert client;
(*
   Zmq.Socket.set_curve_serverkey client server_key;
*)
   Zmq.Socket.connect client "tcp://127.0.0.1:9000";
   
   Zmq.Clock.sleep 1000;
   (*  Send a single message from server to client *)
   Zmq.Str.send server "Hello";
   let message = Zmq.Str.recv client in
   print_endline "Ironhouse test OK";

(*
   zcert_destroy (&client_cert);
   zcert_destroy (&server_cert);
   zauth_destroy (&auth);
   zctx_destroy (&ctx);
*)
