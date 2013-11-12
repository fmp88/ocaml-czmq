let _ =
  let context = Czmq.Context.create () in
  let sender = Czmq.Socket.create context `Push in
  Czmq.Socket.bind sender "tcp://*:5557";

  let sink = Czmq.Socket.create context `Push in
  Czmq.Socket.connect sink "tcp://localhost:5558";
  Printf.printf "Press Enter when the workers are ready: ";
  read_line ();
  print_endline "Sending tasks to workers...";
  Czmq.Str.send sink "0";
  Random.self_init ();
  let total_msec = ref 0 in
  for task_nbr = 0 to 99 do
    let workload = (Random.int 100) + 1 in
    Printf.printf "%d\n" workload;
    total_msec := !total_msec + workload;
    Czmq.Str.send sender (string_of_int workload);(*"%d" workload;*)
  done;
  Printf.printf "Total expected cost: %d msec\n" !total_msec
