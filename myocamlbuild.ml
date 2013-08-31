open Ocamlbuild_plugin

let _ = dispatch & function
  | After_rules ->
      flag ["ocaml"; "compile"; "native"] (A "-S")
  | _ -> ()
