module Utils = struct
    external id : 'a -> 'a = "%identity"

    let maybe a f = function
      | Some a' -> f a'
      | None -> a
end

type ('a, 'acc, 'b) t = { step : 'acc -> 'a -> 'acc
                        ; begin_ : 'acc
                        ; done_ : 'acc -> 'b
                        }

let make step begin_ = { step; begin_; done_=Utils.id }
let run t as_ =
    let v = List.fold_left t.step t.begin_ as_ in
    t.done_ v

let fmap f t = { t with done_ = fun x -> f (t.done_ x) }

let pure b =
    let step = fun () _ -> ()
    and begin_ = ()
    and done_ = fun () -> b in
    { step; begin_; done_ }

let ap t1 t2 =
    let step (acc1, acc2) a = t1.step acc1 a, t2.step acc2 a
    and begin_ = t1.begin_, t2.begin_
    and done_ (acc1, acc2) = (t1.done_ acc1) (t2.done_ acc2) in
    { step; begin_; done_ }

module Infix = struct
    let (<$>) = fmap
    let (<*>) = ap
end

module Operations = struct
    let null =
        let step = fun _ _ -> false in
        { step; begin_=true; done_=Utils.id }

    let and_ = make (&&) true
    let or_ = make (||) false
    let all p = make (fun acc a -> acc && p a) true
    let any p = make (fun acc a -> acc || p a) false

    let sum = make (+) 0
    let sum' = make (+.) 0.0
    let product = make (fun acc a -> acc * a) 1
    let product' = make (fun acc a -> acc *. a) 1.0

    let minimum =
        let step acc a = Some (Utils.maybe a (fun a' -> if a' < a then a' else a) acc) in
        { step; begin_=None; done_=Utils.id }
    let maximum =
        let step acc a = Some (Utils.maybe a (fun a' -> if a' > a then a' else a) acc) in
        { step; begin_=None; done_=Utils.id }

    let length =
        let step l _ = l + 1 in
        { step; begin_=0; done_=Utils.id }
end
