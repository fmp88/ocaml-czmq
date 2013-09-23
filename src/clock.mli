module Clock : sig

  val sleep : int -> unit

  val time : unit -> int64

  val log : string -> unit

  val timestr : unit -> string

end

