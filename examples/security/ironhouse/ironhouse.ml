(*  The Ironhouse Pattern
  
    Security doesn't get any stronger than this. An attacker is going to
    have to break into your systems to see data before/after encryption. *)

let () = 
   (*  Create context and start authentication engine *)
   let ctx = Czmq.Context.create () in
   let auth = Czmq.Auth.create ctx in
   Czmq.Auth.set_verbose auth true;
   Czmq.Auth.allow auth "127.0.0.1";
   
   (*  Tell authenticator to use the certificate store in .curve *)
   Czmq.Auth.configure_curve auth "*" ".curve";
   
   (*  We'll generate a new client certificate and save the public part
       in the certificate store (in practice this would be done by hand
       or some out-of-band process). *)
   let client_cert = Czmq.Cert.create () in
   Czmq.Sys.dir_create (".curve");
   Czmq.Cert.set_meta client_cert "name" "Client test certificate";
   Czmq.Cert.save_public client_cert ".curve/testcert.pub";
   
   (*  Prepare the server certificate as we did in Stonehouse *)
   let server_cert = Czmq.Cert.create () in
   let server_key = Czmq.Cert.public_txt server_cert in
   
   (*  Create and bind server socket *)
   let server = Czmq.Socket.create ctx `Push in
   Czmq.Cert.apply server_cert server;
   Czmq.Socket.set_curve_server server true;
   Czmq.Socket.bind server "tcp://*:9000";

   (*  Create and connect client socket *)
   let client = Czmq.Socket.create ctx `Pull in
   Czmq.Cert.apply client_cert client;
   Czmq.Socket.set_curve_serverkey client server_key;
   Czmq.Socket.connect client "tcp://127.0.0.1:9000";
   
   Czmq.Clock.sleep 1000;
   (*  Send a single message from server to client *)
   Czmq.Str.send server "Hello";
   let message = Czmq.Str.recv client in
   print_endline "Ironhouse test OK";

(*
   zcert_destroy (&client_cert);
   zcert_destroy (&server_cert);
   zauth_destroy (&auth);
   zctx_destroy (&ctx);
*)
