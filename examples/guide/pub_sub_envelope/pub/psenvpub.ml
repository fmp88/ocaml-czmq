let _ = 
  let context = Czmq.Context.create () in
  let publisher = Czmq.Socket.create context `Pub in
  Czmq.Socket.bind publisher "tcp://*:5563";
  while true do
    Czmq.Str.sendx publisher ["A";"We don't want to see this"];
    Czmq.Str.sendx publisher ["B";"We would like to see this"];
    Czmq.Clock.sleep 1000;
  done
