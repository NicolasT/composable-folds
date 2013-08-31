(* Abstract representation of a fold
 *
 * 'a is the input type
 * 'acc is the accumulator type
 * 'b is the result type
 *)
type ('a, 'acc, 'b) t

(* Construct a simple Fold.t
 *
 * The arguments are what you'd pass to List.fold_left, i.e. a processing
 * function and an initial accumulator value.
 *
 * As an example, Operations.sum is defined as
 *
 *     let sum = make (+) 0
 *)
val make : ('acc -> 'a -> 'acc) -> 'acc -> ('a, 'acc, 'acc) t
(* Run a Fold.t over an input list *)
val run : ('a, 'acc, 'b) t -> 'a list -> 'b

(* Functor *)
val fmap : ('b -> 'c) -> ('a, 'acc, 'b) t -> ('a, 'acc, 'c) t

(* Applicative *)
val pure : 'b -> ('a, unit, 'b) t
val ap : ('a, 'acc1, ('b -> 'c)) t -> ('a, 'acc2, 'b) t -> ('a, 'acc1 * 'acc2, 'c) t

module Infix : sig
    (* fmap *)
    val (<$>) : ('b -> 'c) -> ('a, 'acc, 'b) t -> ('a, 'acc, 'c) t
    (* ap *)
    val (<*>) : ('a, 'acc1, ('b -> 'c)) t -> ('a, 'acc2, 'b) t -> ('a, 'acc1 * 'acc2, 'c) t
end

module Operations : sig
    (* Empty input? *)
    val null : ('a, bool, bool) t

    (* All true? *)
    val and_ : (bool, bool, bool) t
    (* At least one true? *)
    val or_ : (bool, bool, bool) t
    (* All predicate applications return true? *)
    val all : ('a -> bool) -> ('a, bool, bool) t
    (* At least one predicate application returns true? *)
    val any : ('a -> bool) -> ('a, bool, bool) t

    val sum : (int, int, int) t
    val sum' : (float, float, float) t
    val product : (int, int, int) t
    val product' : (float, float, float) t

    val minimum : ('a, 'a option, 'a option) t
    val maximum : ('a, 'a option, 'a option) t

    val length : ('a, int, int) t
end
