open Fold.Infix
module FO = Fold.Operations

(* This is a nonsense demo, which can be used to inspect the generated assembly
 * and assure only one fold is performed, as intended *)
let validate l =
    let f = Tuples.pair <$> FO.sum' <*> FO.product' in
    Fold.run f l
