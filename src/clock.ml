module Clock = struct

  let sleep = foreign "zclock_sleep"
    (int @-> returning void)

  let time = foreign "zclock_time"
    (void @-> returning int64_t)

  let log = foreign "zclock_log"
    (string @-> returning void)

  let timestr = foreign "zclock_timestr" 
    (void @-> returning string)

end

