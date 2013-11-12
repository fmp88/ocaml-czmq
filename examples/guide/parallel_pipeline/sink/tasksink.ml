let _ = 
  let context = Czmq.Context.create () in
  let receiver = Czmq.Socket.create context `Pull in
  Czmq.Socket.bind receiver "tcp://*:5558";

  let msg = Czmq.Str.recv receiver in

  let start_time = Unix.time () in
  for task_nbr = 0 to 99 do
    let msg = Czmq.Str.recv receiver in
    if (task_nbr/10)*10 = task_nbr then
      Printf.printf ":"
    else
      Printf.printf ".";
  done;
  Printf.printf "Total elapsed time: %f msec\n" (Unix.time () -. start_time)
