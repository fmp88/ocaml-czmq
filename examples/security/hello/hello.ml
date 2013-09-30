let () = 
  let ctx = Czmq.Context.create () in
  let publisher = Czmq.Socket.create ctx `Pub in
  let ret = Czmq.Socket.set_curve_server publisher true in
  print_endline "Hello, Curve!";
(*
  Czmq.Context.destroy ctx
*)
