let boom () = failwith "Boom"
let no_lwt_frame1 () = boom ()
let no_lwt_frame2 () = no_lwt_frame1 ()
let no_lwt_frame3 () = no_lwt_frame2 ()
let no_lwt_frame4 () = no_lwt_frame3 ()
let no_lwt_frame5 () = no_lwt_frame4 ()
let frame1 ~sleep =
  let%lwt () =
    if sleep
    then Lwt_unix.sleep 1.0
    else Lwt.return_unit
  in
  Lwt.return (no_lwt_frame5 ())
let frame2 ~sleep = let%lwt () = frame1 ~sleep in Lwt.return_unit
let frame3 ~sleep =
  let%lwt () = frame2 ~sleep in
  Lwt.return_unit
let frame4 ~sleep = frame3 ~sleep >> Lwt.return_unit
let frame5 ~sleep = let%lwt () = frame4 ~sleep in Lwt.return_unit
let no_lwt_frame6 ~sleep = frame5 ~sleep
let no_lwt_frame7 ~sleep = no_lwt_frame6 ~sleep
let no_lwt_frame8 ~sleep = no_lwt_frame7 ~sleep
let no_lwt_frame9 ~sleep = no_lwt_frame8 ~sleep

let finally ~sleep = (no_lwt_frame9 ~sleep) [%finally Lwt.return_unit]

let main ~sleep = try%lwt finally ~sleep with exn -> begin
  Printexc.print_backtrace stdout;
  Lwt.return_unit
end

let () = Printf.printf "Lwt stack trace with sleep:\n%!"
let () = Lwt_main.run (main ~sleep:true)

let () = Printf.printf "\n\nLwt stack trace without sleep:\n%!"
let () = Lwt_main.run (main ~sleep:false)
