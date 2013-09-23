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
  

