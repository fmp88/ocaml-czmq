val version : unit -> int * int * int

module Context : sig

  type t 

  (* Create & Destroy *)
  val create : unit -> t
  val destroy : t -> unit 

  (* Setter *)
  val set_io_threads : t -> int -> unit 
  val set_max_sockets : t -> int -> unit 
  val set_ipv6 : t -> bool -> unit 

  (* Getter *)
  val get_io_threads : t -> int
  val get_max_sockets : t -> int
  val get_ipv6 : t -> bool

end

module Socket : sig
   
  type 'a t

  type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
               `Push | `Pull | `Pair]

  val create : Context.t -> kind -> kind t
  val close : kind t -> unit

  val bind : kind t -> string -> unit
  val unbind : kind t -> string -> unit

  val connect : kind t -> string -> unit  
  val disconnect : kind t -> string -> unit  

  type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
  val send : kind t -> ?flag:snd_flag -> string -> unit

  type recv_flag = None | Dontwait
  val recv : ?flag:recv_flag -> kind t -> string

end

module Poll : sig

  type t

  type poll_t

  type event = In | Out | InOut
  type item = (Socket.kind Socket.t * event)

(*val mask : item array -> t*)
  val mask :(unit Ctypes.ptr * event) Ctypes.Array.t ->
           poll_t Ctypes.structure Ctypes.Array.t
(*
  val poll : ?timeout: int -> t event option array
*)
end
  
module Options : sig
  
end

