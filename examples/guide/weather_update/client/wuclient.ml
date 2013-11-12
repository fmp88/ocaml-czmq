let _ = 
  let context = Czmq.Context.create () in
  
  (* Socket to talk to server *)
  Printf.printf "Collecting updates from weather server...\n";
  let subscriber = Czmq.Socket.create context `Sub in
  Czmq.Socket.connect subscriber "tcp://localhost:5556";

  (* Subscribe to zipcode, default is NYC, 10001*)
  let filter = if Array.length Sys.argv > 1 then Array.get Sys.argv 1 else "10001"
  in
  Czmq.Socket.set_subscribe subscriber filter;
  let total_temp = ref 0 in
  let bound = 99 in
  for update_nbr = 0 to bound do
    let msg = Czmq.Str.recv subscriber in
    print_endline msg;
    let (zipcode,temperature,relhumidity) = 
      Scanf.sscanf msg "%d %d %d" (fun z t r -> (z,t,r)) 
    in
    total_temp := !total_temp + temperature;
    Printf.printf "%d\n" update_nbr;
  done;
  Printf.printf "Average temperature for zipcode '%s' was %d\n" filter (!total_temp / bound)
