module Dict.ManyToOne exposing (fromList, from, innerJoin, select)

{-| Joinable implementation of SQL many-to-one relation

@docs fromList, from, innerJoin, select

-}

import Dict exposing (Dict)
import Dict.Joinable


type ManyToOne comparable a
    = ManyToOne (List ( comparable, a ))


{-| The way to init the container from a list of pair
-}
fromList : List ( comparable, a ) -> ManyToOne comparable a
fromList =
    ManyToOne


{-| Used for clarity only and match SQL queries
-}
select : a -> a
select =
    identity


{-| Equivalent to SQL `FROM`
-}
from : ManyToOne comparable a -> (List a -> result) -> Dict comparable result
from =
    Dict.Joinable.from manyToOneToDict


{-| Equivalent to SQL `INNER JOIN`
-}
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
