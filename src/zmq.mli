val version : unit -> int * int * int

module Socket : sig
 (*  
  type 'a t

  type kind = Req | Rep | Dealer | Router | Pub | Sub | XPub | XSub |
              Push | Pull | Pair 
*)
  module Context : sig
  
    type t 

    (* Create & Destroy *)
    val create : unit -> t
(*  val destroy : t -> unit 

    (* Setter *)
    val set_io_threads : t -> int -> unit 
    val set_max_sockets : t -> int -> unit 
    val set_ipv6 : t -> bool -> unit 

    (* Getter *)
    val get_io_threads : t -> int
    val get_max_sockets : t -> int
    val get_ipv6 : t -> bool
*)
  end

end
(*
  val create : Context.t -> kind -> kind t
  val close : kind t -> unit

  val bind : kind t -> string -> unit
  val unbind : kind t -> string -> unit

  val connect : kind t -> string -> unit  
  val disconnect : kind t -> string -> unit  

  module Options : sig
    
  end

end
*)
