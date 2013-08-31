open Fold.Infix
module FO = Fold.Operations

module Utils = struct
    let string_of_option f = function
      | Some x -> Printf.sprintf "Some %s" (f x)
      | None -> "None"

    let div a b = float_of_int a /. float_of_int b

    let string_of_list f l =
        let l' = List.map f l in
        let s = String.concat "; " l' in
        Printf.sprintf "[%s]" s
end

let main () =
    let l = [1; 2; 3; 4; 3; 2; 1] in

    Printf.printf "Input: %s\n" (Utils.string_of_list string_of_int l);

    (* Basic fold *)
    let max = Fold.run FO.maximum l in
    Printf.printf "Maximum: %s\n" (Utils.string_of_option string_of_int max);

    (* Keep track of 2 values & combine them in the end *)
    let average = Utils.div <$> FO.sum <*> FO.length in
    Printf.printf "Average: %f\n" (Fold.run average l);

    (* Keep track of 3 results, returning them as-is *)
    let spl = Tuples.triple <$> FO.sum
                            <*> FO.product
                            <*> FO.length
    in
    let (s, p, l) = Fold.run spl l in
    Printf.printf "Sum: %d, product: %d, length: %d\n" s p l
;;

main ()
