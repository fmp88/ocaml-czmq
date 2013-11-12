let _ = 
  let context = Czmq.Context.create () in
  
  (*  First, connect our subscriber socket *)
  let subscriber = Czmq.Socket.create context `Sub in
  Czmq.Socket.connect subscriber "tcp://localhost:5561";
  Czmq.Socket.set_subscribe subscriber "";

  (* 0MQ is so fast, we need to wait a while... *)
  Czmq.Clock.sleep 1000;

  (* Second, synchronize with publisher *)
  let syncclient = Czmq.Socket.create context `Req in
  Czmq.Socket.connect syncclient "tcp://localhost:5562";

  (* send a synchronization request *)
  Czmq.Str.send syncclient "";
 
  (* wait for synchronization reply *)
  let msg = Czmq.Str.recv syncclient in

  let continue = ref true in
  let update_nbr = ref 0 in
  while !continue do
    let msg = Czmq.Str.recv subscriber in
    if msg = "END" then
      continue := false
    else 
      update_nbr := !update_nbr + 1
  done;
  Printf.printf "Received %d updates\n" !update_nbr
