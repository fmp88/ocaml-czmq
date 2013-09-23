module Certstore : sig
 
  type t

  val create : string -> t

  val lookup : t -> string -> Cert.t

  val dump : t -> unit

end

