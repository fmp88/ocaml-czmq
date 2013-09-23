type 'a t

type kind = [`Req | `Rep | `Dealer | `Router | `Pub | `Sub | `XPub | `XSub |
             `Push | `Pull | `Pair]

val create : Context.t -> kind -> kind t
val destroy : Context.t -> kind t -> unit

val bind : kind t -> string -> unit
val unbind : kind t -> string -> unit

val connect : kind t -> string -> unit  
val disconnect : kind t -> string -> unit  

type snd_flag = None | Dontwait | Sndmore | Dontwait_Sndmore
val send : kind t -> ?flag:snd_flag -> string -> unit

type recv_flag = None | Dontwait
val recv : ?flag:recv_flag -> kind t -> string
