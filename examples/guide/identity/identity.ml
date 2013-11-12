let _ = 
  let context = Czmq.Context.create () in
  let sink = Czmq.Socket.create context `Router in
  Czmq.Socket.bind sink "inproc://example";

  let anonymous = Czmq.Socket.create context `Req in
  Czmq.Socket.connect anonymous "inproc://example";
  Czmq.Str.send anonymous "Router uses a generated UUID";
  (* missing dump function *)

  let identified = Czmq.Socket.create context `Req in
  Czmq.Socket.set_identity identified "PEERZ";
  Czmq.Socket.connect identified "inproc://example";
  Czmq.Str.send identified "Router socket uses REQ's socket identity";
  (* missing dump function *)
