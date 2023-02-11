module Dict.ManyToOne exposing (from, fromList, innerJoin, select)

import Dict exposing (Dict)
import Dict.Joinable


type ManyToOne comparable a
    = ManyToOne (List ( comparable, a ))


fromList : List ( comparable, a ) -> ManyToOne comparable a
fromList =
    ManyToOne


select : a -> a
select =
    identity


from : ManyToOne comparable a -> (List a -> result) -> Dict comparable result
from =
    Dict.Joinable.from manyToOneToDict


innerJoin : ManyToOne comparable a -> Dict comparable (List a -> result) -> Dict comparable result
innerJoin =
    Dict.Joinable.innerJoin manyToOneToDict


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
