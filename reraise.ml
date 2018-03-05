(* This test should show a better stack trace, since ignore_result won't throw
 * away the exc *)
let test_ignore_result_caught_exception () =
  Printf.printf "ignore_result with caught exception:\n%!";
  let boom () = failwith "Boom" in
  let no_lwt_frame1 () = boom () in
  let no_lwt_frame2 () = no_lwt_frame1 () in
  let no_lwt_frame3 () = no_lwt_frame2 () in
  let no_lwt_frame4 () = no_lwt_frame3 () in
  let no_lwt_frame5 () = no_lwt_frame4 () in
  let call_ignore_result () = try Lwt.return (no_lwt_frame5 ()) with exn -> Lwt.fail exn in
  let no_lwt_frame6 () = call_ignore_result () in
  let no_lwt_frame7 () = no_lwt_frame6 () in
  let no_lwt_frame8 () = no_lwt_frame7 () in
  let no_lwt_frame9 () = no_lwt_frame8 () in
  let thread = no_lwt_frame9 () in
  try Lwt.ignore_result thread
  with exn -> Printexc.print_backtrace stdout

(* This test should not change behavior, since reraising a new exception
 * is the same as a raise *)
let test_ignore_result_new_exception () =
  Printf.printf "\n\nignore_result with new exception:\n%!";
  let call_ignore_result () = Lwt.fail Exit in
  let no_lwt_frame1 () = call_ignore_result () in
  let no_lwt_frame2 () = no_lwt_frame1 () in
  let no_lwt_frame3 () = no_lwt_frame2 () in
  let no_lwt_frame4 () = no_lwt_frame3 () in
  let thread = no_lwt_frame4 () in
  try Lwt.ignore_result thread
  with exn -> Printexc.print_backtrace stdout

let test_lwt_main_caught_exception () =
  Printf.printf "\n\nLwt_main.run:\n%!";
  let boom () = failwith "Boom" in
  let no_lwt_frame1 () = boom () in
  let no_lwt_frame2 () = no_lwt_frame1 () in
  let no_lwt_frame3 () = no_lwt_frame2 () in
  let no_lwt_frame4 () = no_lwt_frame3 () in
  let no_lwt_frame5 () = no_lwt_frame4 () in
  let call_ignore_result () = try Lwt.return (no_lwt_frame5 ()) with exn -> Lwt.fail exn in
  let no_lwt_frame6 () = call_ignore_result () in
  let no_lwt_frame7 () = no_lwt_frame6 () in
  let no_lwt_frame8 () = no_lwt_frame7 () in
  let no_lwt_frame9 () = no_lwt_frame8 () in
  let thread = no_lwt_frame9 () in
  try Lwt_main.run thread
  with exn -> Printexc.print_backtrace stdout

(* This test should not change behavior, since reraising a new exception
 * is the same as a raise *)
let test_lwt_main_new_exception () =
  Printf.printf "\n\nignore_result with new exception:\n%!";
  let call_ignore_result () = Lwt.fail Exit in
  let no_lwt_frame1 () = call_ignore_result () in
  let no_lwt_frame2 () = no_lwt_frame1 () in
  let no_lwt_frame3 () = no_lwt_frame2 () in
  let no_lwt_frame4 () = no_lwt_frame3 () in
  let thread = no_lwt_frame4 () in
  try Lwt_main.run thread
  with exn -> Printexc.print_backtrace stdout


let () = test_ignore_result_caught_exception ()
let () = test_ignore_result_new_exception ()
let () = test_lwt_main_caught_exception ()
let () = test_lwt_main_new_exception ()
