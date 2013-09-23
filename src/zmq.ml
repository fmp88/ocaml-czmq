open Ctypes
open PosixTypes
open Foreign
open Unsigned

exception General_Error of string

let version () = 
  let zmq_version_stub = foreign "zmq_version" 
    (ptr int @-> ptr int @-> ptr int @-> returning void)
  in
  let major = allocate int 0 in
  let minor = allocate int 0 in
  let patch = allocate int 0 in
  zmq_version_stub major minor patch;
  (!@major,!@minor,!@patch)


module Options = struct 
 
end


