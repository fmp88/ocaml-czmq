module Auth : sig

  type t 

  val create : Context.t -> t

  val allow : Context.t -> string -> unit

  val deny : Context.t -> string -> unit

  val configure_plain : Context.t -> string -> string -> unit

  val configure_curve : Context.t -> string -> string -> unit

end


