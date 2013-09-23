type t 

(* Create & Destroy *)
val create : unit -> t
val destroy : t -> unit 

(* Setter *)
val set_io_threads : t -> int -> unit 
val set_linger : t -> int -> unit
val set_pipehwm : t -> int -> unit
val set_sndhwm : t -> int -> unit
val set_rcvhwm : t -> int -> unit
(*
val set_max_sockets : t -> int -> unit 
val set_ipv6 : t -> bool -> unit 
*)
(*
(* Getter *)
val get_io_threads : t -> int
val get_max_sockets : t -> int
val get_ipv6 : t -> bool
*)
