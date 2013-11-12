let _ = 
  let context = Czmq.Context.create () in
  let publisher = Czmq.Socket.create context `Pub in
  Czmq.Socket.bind publisher "tcp://*:5556";

  Random.self_init ();
  while true do
    let zipcode = Random.int 100000 in
    let temperature = (Random.int 215) - 80 in
    let relhumidity = (Random.int 50) + 10 in
    let update = Printf.sprintf "%05d %d %d" zipcode temperature relhumidity in
    Czmq.Str.send publisher update;
  done
