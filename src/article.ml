let process_command cmd =
  Printf.printf "%s\n" cmd

let translate_file () =
  (* Preamble *)
  Output.print_comment "This file was generated by Holide.";
  Output.print_command "NAME" [Input.get_module_name ()];
  Output.print_command "IMPORT" ["hol"];
  (* Main section *)
  let rec process_commands () =
    let cmd = Input.read_line () in
    process_command cmd;
    process_commands () in
  try process_commands ()
  with End_of_file -> ()
