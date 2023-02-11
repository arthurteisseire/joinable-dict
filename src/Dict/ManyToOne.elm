module Dict.ManyToOne exposing (..)

import Dict exposing (Dict)


type ManyToOne comparable a
    = ManyToOne (List ( comparable, a ))


select : a -> a
select =
    identity


fromList : List ( comparable, a ) -> ManyToOne comparable a
fromList =
    ManyToOne


from : ManyToOne comparable a -> (List a -> result) -> Dict comparable result
from manyToOne func =
    Dict.map (\_ -> func) (manyToOneToDict manyToOne)


innerJoin : ManyToOne comparable a -> Dict comparable (List a -> result) -> Dict comparable result
innerJoin =
    andInnerMap


andInnerMap : ManyToOne comparable a -> Dict comparable (List a -> result) -> Dict comparable result
andInnerMap =
    innerMap2 (|>)


innerMap2 :
    (List a -> b -> result)
    -> ManyToOne comparable a
    -> Dict comparable b
    -> Dict comparable result
innerMap2 func listA dictB =
    innerMerge
        (\entityId a b result -> Dict.insert entityId (func a b) result)
        listA
        dictB
        Dict.empty


innerMerge :
    (comparable -> List a -> b -> result -> result)
    -> ManyToOne comparable a
    -> Dict comparable b
    -> result
    -> result
innerMerge func manyToOne =
    manyToOneToDict manyToOne
        |> Dict.merge
            (\_ _ -> identity)
            func
            (\_ _ -> identity)


manyToOneToDict : ManyToOne comparable a -> Dict comparable (List a)
manyToOneToDict (ManyToOne manyToOne) =
    List.foldl
        (\( id, a ) result ->
            case Dict.get id result of
                Just listA ->
                    Dict.insert id (listA ++ [ a ]) result

                Nothing ->
                    Dict.insert id [ a ] result
        )
        Dict.empty
        manyToOne
