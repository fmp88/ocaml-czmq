module type Ser = sig

  type t

  val decode : string -> t

  val encode : t -> string 

end

module Make (S : Ser ) = struct 
 
  type t = S.t
  
  let send socket msg = Str.send socket (S.encode msg)

  let sendx socket msg_list = Str.sendx socket (List.map (fun msg -> S.encode msg) msg_list)

  let recv socket = S.decode (Str.recv socket)

end

(*
module Json = Make(struct 
                   type t = Json.t 
                   let decode = Json.decode 
                   let encode Json.encode end)
*)
