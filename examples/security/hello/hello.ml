let () = 
  let ctx = Zmq.Context.create () in
  let publisher = Zmq.Socket.create ctx `Pub in
  let ret = Zmq.Socket.set_curve_server publisher true in
  print_endline "Hello, Curve!";
(*
  Zmq.Context.destroy ctx
*)
