open Flickr
open Tools
module Xml = Twitter.Xml

let xml_parse () =
  let xml = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>
<rsp stat=\"fail\">
	<err code=\"2\" msg=\"No photo specified\" />
</rsp>
" in
  Xml.parse_string xml


let auth_file = "ocaml_flickr.auth"

let o = get_oauth auth_file

let getInfo pid o =
  match Photos.getInfo pid o with
  | `Error e -> error e
  | `Ok j -> ocaml_format_with Photos.GetInfo.ocaml_of_photo j


(*
let () = delete_dups_in_sets ()
*)

(*
let () = Photosets.getList o |> fail_at_error |> ocaml_format_with Photosets.GetList.ocaml_of_t
*)

(*
let () = Flickr.Upload.upload "test.jpg" o |> fail_at_error |> 
    fun xs ->    prerr_endline (String.concat ", " xs)
*)

let user = get_current_user o |> fail_at_error

let () = Photos.search ~user_id:user#id o |> fail_at_error |> json_format