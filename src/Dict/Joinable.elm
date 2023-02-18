module Dict.Joinable exposing (from, innerJoin, leftOuterJoin)

{-| Let you create any joinable type easily.

This is the api used by `Dict.OneToOne` and `Dict.ManyToOne` implementations.
A good other container implementation would be a database table with a forward key in addition to the primary key.

To make your container "joinable", you just need to provide a way to convert it into a `Dict`.
Then add a `from`, `innerJoin` and (optionally) `leftOuterJoin` method like this:

    from =
        Dict.Joinable.from convertMyContainerToDict

    innerJoin =
        Dict.Joinable.innerJoin convertMyContainerToDict

    leftOuterJoin =
        Dict.Joinable.leftOuterJoin convertMyContainerToDict

    convertMyContainerToDict : MyContainer a -> Dict comparable a
    convertMyContainerToDict =
        ...

@docs from, innerJoin, leftOuterJoin

-}

import Dict exposing (Dict)
import Maybe exposing (Maybe)


{-| Equivalent to SQL `FROM`
-}
from : (joinable -> Dict comparable a) -> joinable -> (a -> result) -> Dict comparable result
from toDict joinable func =
    Dict.map (\_ -> func) (toDict joinable)


{-| Equivalent to SQL `INNER JOIN`
-}
innerJoin : (joinable -> Dict comparable a) -> joinable -> Dict comparable (a -> result) -> Dict comparable result
innerJoin toDict joinable =
    andInnerMap (toDict joinable)


{-| Equivalent to SQL `LEFT OUTER JOIN`
-}
leftOuterJoin : (joinable -> Dict comparable a) -> joinable -> Dict comparable (Maybe a -> result) -> Dict comparable result
leftOuterJoin toDict joinable =
    andLeftOuterMap (toDict joinable)



-- Inner join


andInnerMap : Dict comparable a -> Dict comparable (a -> result) -> Dict comparable result
andInnerMap =
    innerMap2 (|>)


innerMap2 :
    (a -> b -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> Dict comparable result
innerMap2 func dictA dictB =
    innerMerge
        (\entityId a b result -> Dict.insert entityId (func a b) result)
        dictA
        dictB
        Dict.empty


innerMerge :
    (comparable -> a -> b -> result -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> result
    -> result
innerMerge func =
    Dict.merge
        (\_ _ -> identity)
        func
        (\_ _ -> identity)



-- Outer join


andLeftOuterMap : Dict comparable a -> Dict comparable (Maybe a -> result) -> Dict comparable result
andLeftOuterMap =
    leftOuterMap2 (|>)


leftOuterMap2 :
    (Maybe a -> b -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> Dict comparable result
leftOuterMap2 func dictA dictB =
    leftOuterMerge
        (\entityId a b result -> Dict.insert entityId (func a b) result)
        dictA
        dictB
        Dict.empty


leftOuterMerge :
    (comparable -> Maybe a -> b -> result -> result)
    -> Dict comparable a
    -> Dict comparable b
    -> result
    -> result
leftOuterMerge func =
    Dict.merge
        (\_ _ -> identity)
        (\key a b result -> func key (Just a) b result)
        (\key b result -> func key Nothing b result)
