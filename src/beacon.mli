module Beacon : sig

  type t

  val create : int -> t

  val hostname : t -> string

  val set_interval : t -> int -> unit

  val noecho : t -> unit

  val silence : t -> unit 

end

